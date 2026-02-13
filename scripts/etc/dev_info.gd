extends Label

@onready var dps_timer: Timer = $DPSTimer

var speed: float:
	get:
		return owner.speed
var speed_multiplier: float:
	get:
		return owner.speed_multiplier

var total_damage: float = 0.0
var damage_this_second: float = 0.0
var current_dps: float = 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	text = """
	Speed: %d
	DPS: %d
	Total Damage: %d
	""" % [speed * speed_multiplier, current_dps, total_damage]

func take_damage(damage: float) -> void:
	total_damage += damage
	damage_this_second += damage
	
	if dps_timer.is_stopped():
		dps_timer.start()

func _on_dps_timer_timeout() -> void:
	current_dps = damage_this_second
	
	damage_this_second = 0.0
