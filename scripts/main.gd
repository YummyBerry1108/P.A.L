extends Node2D

@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var time_label: Label = $UI/TimeLabel
@onready var player_container: Node2D = $PlayerContainer
@onready var enemy_container: Node2D = $EnemyContainer
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var enemy_spawner: MultiplayerSpawner = $EnemySpawner

var player_scene: Resource = preload("res://scenes/player/player.tscn")
var player_amount: int = 0
var player_died_amount: int = 0
var time_elapsed: float = 0.0
var is_timer_running: bool = true

func _ready() -> void:
	Lobby.player_loaded.rpc_id(1) # Tell server this client is ready
	Lobby.server_disconnected.connect(_on_server_disconnected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	player_spawner.spawned.connect(_on_player_spawned)
	enemy_spawner.spawned.connect(_on_enemy_spawned)

func _process(delta: float) -> void:
	if is_timer_running:
		time_elapsed += delta
		_update_timer_ui()

func _update_timer_ui() -> void:
	if not multiplayer.is_server():
		return

	var minutes = floor(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	
	time_label.text = "%02d:%02d" % [minutes, seconds]

func _on_enemy_spawned(node: Enemy) -> void:
	pass

# Called only on the server.
func _add_player_node(id: int) -> void:
	var player: Player = player_scene.instantiate()
	player.global_position = Vector2.ZERO
	player.name = str(id)
	player.add_to_group("players")
	player_container.add_child(player)
	player.player_died.connect(_on_player_died)
	
	if id == 1:
		_on_player_spawned(player)
		
func _on_player_spawned(node: Player) -> void:
	#print("ID: ",  multiplayer.get_unique_id())
	#print("Spawn: ", node.name)
	if not multiplayer.is_server():
		node.player_died.connect(_on_player_died)
	if node.is_multiplayer_authority():
		node.health_changed.connect(health_bar._set_health)
		health_bar.init_health(node.hp)
		
func _on_player_disconnected(id: int) -> void:
	player_amount -= 1
	
	if multiplayer.is_server() and player_container.has_node(str(id)):
		var disconnect_player: Player = player_container.get_node(str(id))
		if not disconnect_player.is_alive:
			player_died_amount -= 1
		# What if player shoot a projectile that didn't disappear yet?
		disconnect_player.queue_free()
	
	_check_game_over()

func _on_player_died(id: int) -> void:
	#print("In ", multiplayer.get_unique_id())
	#print("ID: ", id, " die!")
	player_died_amount += 1
	if multiplayer.is_server() and player_container.has_node(str(id)):
		var disconnect_player: Player = player_container.get_node(str(id))
		disconnect_player.remove_from_group("players")
	_check_game_over()

func _check_game_over() -> void:
	if player_died_amount == player_amount:
		if multiplayer.is_server():
			for enemy: Enemy in enemy_container.get_children():
				enemy.queue_free()
			for player: Player in player_container.get_children():
				player.queue_free()
		await get_tree().create_timer(3.0).timeout
		if multiplayer.is_server():
			Lobby.return_to_lobby.rpc()
		
		#_game_over.rpc()

func _on_server_disconnected() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

@rpc("authority", "call_local", "reliable")
func _game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	
func spawn_enemy(enemy_name: String = "rock", amount: int = 1) -> void:
	for i in range(amount):
		var enemy_node: PackedScene = load("res://scenes/enemies/" + enemy_name + ".tscn")
		var new_enemy: Enemy = enemy_node.instantiate()
		var x = randf_range(1, 3) * (randi()%2)*2 - 1 # -1 or 1
		var y = randf_range(1, 3) * (randi()%2)*2 - 1
		new_enemy.global_position = Vector2(x, y) * 500
		enemy_container.add_child(new_enemy, true)

# Called only on the server.
func start_game() -> void:
	print("Game Start!")
	for player_id in Lobby.players:
		_add_player_node(player_id) 
		player_amount += 1
	
	spawn_enemy("rabbit", 1)
	spawn_enemy("rock", 1)
	spawn_enemy("snail", 1)
	

	
