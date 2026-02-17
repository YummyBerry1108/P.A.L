class_name Dummy extends Enemy

@onready var dev_info: Label = $DevInfo
@onready var dps_timer: Timer = $DevInfo/DPSTimer

var total_damage: float = 0.0

var damage_this_second: float = 0.0
var current_dps: float = 0.0


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if knockback_component.knockback_check(delta):
		move_and_slide()

func die() -> void:
	pass
