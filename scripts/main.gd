extends Node2D

@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var time_label: Label = $UI/TimeLabel
@onready var player_container: Node2D = $PlayerContainer
@onready var enemy_container: Node2D = $EnemyContainer
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var enemy_spawner: MultiplayerSpawner = $EnemySpawner

var player_scene = preload("res://scenes/player/player.tscn")
var time_elapsed: float = 0.0
var is_timer_running: bool = true

func _ready() -> void:
	Lobby.player_loaded.rpc_id(1)
	Lobby.server_disconnected.connect(_game_over)
	player_spawner.spawned.connect(_on_player_spawned)
	enemy_spawner.spawned.connect(_on_enemy_spawned)

func _process(delta: float) -> void:
	if is_timer_running:
		time_elapsed += delta
		_update_timer_ui()

func _on_player_spawned(node: Player) -> void:
	#print("ID: ",  multiplayer.get_unique_id())
	#print("Spawn: ", node.name)
	if node.is_multiplayer_authority():
		node.health_changed.connect(health_bar._set_health)
		health_bar.init_health(node.hp)

func _on_enemy_spawned(node: Enemy) -> void:
	pass

func _add_player_node(id) -> void:
	var player: Player = player_scene.instantiate()
	player.global_position = Vector2.ZERO
	player.name = str(id)
	player.add_to_group("players")
	player_container.add_child(player)
	
	if id == 1:
		_on_player_spawned(player)

func _on_player_disconnected(id) -> void:
	if player_container.has_node(str(id)):
		player_container.get_node(str(id)).queue_free()

func _update_timer_ui() -> void:
	if not multiplayer.is_server():
		return

	var minutes = floor(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	
	time_label.text = "%02d:%02d" % [minutes, seconds]
	
func _game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
func spawn_enemy(enemy_name: String = "rock", amount: int = 1) -> void:
	for i in range(amount):
		var enemy_node: PackedScene = load("res://scenes/enemies/" + enemy_name + ".tscn")
		var new_enemy: Enemy = enemy_node.instantiate()
		new_enemy.global_position = Vector2(randf()*2 - 1, randf()*2 - 1) * 500
		enemy_container.add_child(new_enemy, true)

# Called only on the server.
func start_game():
	print("Game Start!")
	for player_id in Lobby.players:
		_add_player_node(player_id) 
	
	spawn_enemy("rabbit", 1)
	spawn_enemy("rock", 1)
	spawn_enemy("snail", 1)
	

	
