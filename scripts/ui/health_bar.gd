extends ProgressBar

@onready var timer: Timer = $Timer
@onready var damage_bar: ProgressBar = $DamageBar

var health: float = 0.0

func _ready() -> void:
	await  get_tree().process_frame
	
	var player_node = get_parent()
	
	if not player_node.is_multiplayer_authority():
		hide()
		set_process(false)
	else:
		show()

func _set_health(new_health: float) -> void:
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		value = 0
		damage_bar.value = 0
	
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func init_health(_health: float) -> void:
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
