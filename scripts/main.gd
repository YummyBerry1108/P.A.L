extends Node2D

@export_category("Resource")
@export var ui: Control
@export var player_scene: PackedScene
@export var exp_orb_scene: PackedScene

@onready var player_container: Node2D = $PlayerContainer
@onready var enemy_container: Node2D = $EnemyContainer
@onready var exp_orb_container: Node2D = $ExpOrbContainer
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var enemy_spawner: MultiplayerSpawner = $EnemySpawner

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
	
	ui.exp_bar.value = 0
	ui.exp_label.text = "Level: 0"
	ui.spectate_label.hide()

func _process(delta: float) -> void:
	if is_timer_running:
		time_elapsed += delta
		_update_timer_ui()
	
	# press R
	if multiplayer.is_server() and Input.is_action_pressed("force_game_over"):
		_game_over()
	
	# press E
	if Input.is_action_pressed("get_exp"):
		ui.exp_bar.add_experience(1)

func _update_timer_ui() -> void:
	if not multiplayer.is_server():
		return

	var minutes = floor(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	
	ui.time_label.text = "%02d:%02d" % [minutes, seconds]

func _update_spectate_ui(new_text: String) -> void:
	ui.spectate_label.text = "Spectating: " + new_text
	ui.spectate_label.show()

func _on_enemy_spawned(_enemy: Enemy) -> void:
	pass

## Give exp to main game
func _on_enemy_died(enemy: Enemy) -> void:
	var exp_orb: CharacterBody2D = exp_orb_scene.instantiate()
	exp_orb.global_position = enemy.global_position
	exp_orb.exp_amount = enemy.exp_amount
	exp_orb.collected.connect(ui.exp_bar.add_experience)
	exp_orb_container.call_deferred("add_child", exp_orb, true)

func _on_player_spawned(player: Player) -> void:
	if not multiplayer.is_server():
		player.player_died.connect(_on_player_died)
	if player.is_multiplayer_authority():
		GameManager.local_player = player
		player.health_changed.connect(ui.health_bar._set_health)
		player.max_health_changed.connect(ui.health_bar.init_health)
		player.spectate_changed.connect(_update_spectate_ui)
		ui.health_bar.init_health(player.hp)
		
func _on_player_disconnected(id: int) -> void:
	player_amount -= 1
	
	if multiplayer.is_server() and player_container.has_node(str(id)):
		var disconnect_player: Player = player_container.get_node(str(id))
		if not disconnect_player.is_alive:
			player_died_amount -= 1
		else:
			disconnect_player.remove_from_group("players")
		# What if player shoot a projectile that didn't disappear yet?
		disconnect_player.queue_free()
	_check_game_over()

func _on_player_died(id: int) -> void:
	player_died_amount += 1
	if multiplayer.is_server() and player_container.has_node(str(id)):
		var disconnect_player: Player = player_container.get_node(str(id))
		disconnect_player.remove_from_group("players")
	_check_game_over()

## All client will receive
func _on_server_disconnected() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
func _check_game_over() -> void:
	if player_died_amount == player_amount:
		_game_over()

func _game_over() -> void:
	if multiplayer.is_server():
		for enemy: Enemy in enemy_container.get_children():
			enemy.queue_free()
		for player: Player in player_container.get_children():
			player.queue_free()
	await get_tree().create_timer(1.0).timeout
	if multiplayer.is_server():
		Lobby.return_to_lobby.rpc()
	
func _spawn_enemy(enemy_name: String = "rock", amount: int = 1) -> void:
	if not multiplayer.is_server():
		return
		
	for i in range(amount):
		var enemy_node: PackedScene = load("res://scenes/enemies/" + enemy_name + ".tscn")
		var new_enemy: Enemy = enemy_node.instantiate()
		var x = randf_range(1, 3) * (randi()%2)*2 - 1 # -1 or 1
		var y = randf_range(1, 3) * (randi()%2)*2 - 1
		new_enemy.global_position = Vector2(x, y) * 300
		new_enemy._on_enemy_died.connect(_on_enemy_died)
		enemy_container.add_child(new_enemy, true)
		
## Called only on the server.
func _add_player_node(id: int) -> void:
	var player: Player = player_scene.instantiate()
	player.global_position = Vector2.ZERO
	player.name = str(id)
	player.player_died.connect(_on_player_died)
	player_container.add_child(player)
	
	if id == 1:
		_on_player_spawned(player)
		
## Called only on the server.
func start_game() -> void:
	print("Game Start!")
	for player_id in Lobby.players:
		_add_player_node(player_id) 
		player_amount += 1
	
	_spawn_enemy("rabbit", 1)
	_spawn_enemy("rock", 1)
	_spawn_enemy("snail", 3)
	

	
