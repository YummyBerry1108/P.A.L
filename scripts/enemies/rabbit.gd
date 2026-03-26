extends Enemy

@export var fire_trail_scene: PackedScene

@onready var state_timer: Timer = $StateTimer

@export var dash_speed: float = 900.0
@export var chase_duration: float = 0.5
@export var target_duration: float = 0.5
@export var lock_duration: float = 0.5 
@export var dash_duration: float = 1
@export var idle_duration: float = 0.5

func _ready() -> void:
	speed = 250
	super()

func _set_up_variant_stat() -> void:
	match variant_type:
		VariantType.normal:
			hp *= multiplier
			animated_sprite_2d.play("red")
		VariantType.elite:
			hp *= multiplier * 2
			animated_sprite_2d.play("blue")
			lock_duration = 0.1
			target_duration = 0.15
			damage *= multiplier
			speed *= player_speed_ref/speed
