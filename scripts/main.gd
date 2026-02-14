extends Node2D

@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var time_label: Label = $UI/TimeLabel

var time_elapsed: float = 0.0
var is_timer_running: bool = true

func _ready() -> void:
	for i in range(500):
		#spawn_enemy()
		pass

func _process(delta: float) -> void:
	if is_timer_running:
		time_elapsed += delta
		update_timer_ui()

func _on_player_spawned(player_instance: Player) -> void:
	if player_instance.is_multiplayer_authority():
		player_instance.health_changed.connect(health_bar.set_health)
		health_bar.init_health(player_instance.hp)

func update_timer_ui() -> void:
	var minutes = floor(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	
	time_label.text = "%02d:%02d" % [minutes, seconds]
	
func spawn_enemy() -> void:
	var enemy_node: PackedScene = load("res://scenes/enemies/" + 'rock' + ".tscn")
	var new_enemy: Enemy = enemy_node.instantiate()
	new_enemy.global_position = Vector2(randf(), randf()) * 100
	add_child(new_enemy)
	
