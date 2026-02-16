extends Node2D

@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var time_label: Label = $UI/TimeLabel
@onready var player_container: Node2D = $PlayerContainer
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner

var player_scene = preload("res://scenes/player/player.tscn")
var time_elapsed: float = 0.0
var is_timer_running: bool = true

func _ready() -> void:
	for i in range(100):
		#spawn_enemy()
		pass
	spawner.spawned.connect(_on_spawned)
	
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(_on_player_connected)
		multiplayer.peer_disconnected.connect(_on_player_disconnected)
		
		_on_player_connected(1)

func _process(delta: float) -> void:
	if is_timer_running:
		time_elapsed += delta
		_update_timer_ui()

func _on_spawned(node: Player) -> void:
	print("Author: ",  multiplayer.get_unique_id())
	print("Spawn: ", node)
	if node.is_multiplayer_authority():
		node.health_changed.connect(health_bar._set_health)
		health_bar.init_health(node.hp)

func _on_player_connected(id) -> void:
	var player: Player = player_scene.instantiate()
	player.global_position = Vector2.ZERO
	player.name = str(id)
	player.add_to_group("players")
	player_container.add_child(player)
	
	if id == 1:
		player.health_changed.connect(health_bar._set_health)
		health_bar.init_health(player.hp)

func _on_player_disconnected(id) -> void:
	if player_container.has_node(str(id)):
		player_container.get_node(str(id)).queue_free()

func _update_timer_ui() -> void:
	if not multiplayer.is_server():
		return

	var minutes = floor(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	
	time_label.text = "%02d:%02d" % [minutes, seconds]
	
func spawn_enemy() -> void:
	var enemy_node: PackedScene = load("res://scenes/enemies/" + "rock" + ".tscn")
	var new_enemy: Enemy = enemy_node.instantiate()
	new_enemy.global_position = Vector2(randf(), randf()) * 100
	add_child(new_enemy)
	
