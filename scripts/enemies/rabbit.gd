extends Enemy

@export var fire_trail_scene: PackedScene

@onready var state_timer: Timer = $StateTimer

@export var dash_speed: float = 900.0
@export var target_duration: float = 0.5
@export var lock_duration: float = 0.5 
@export var dash_duration: float = 1
@export var idle_duration: float = 0.5

func _ready() -> void:
	super()
	speed = 250

func _set_up_variant_stat() -> void:
	match variant_type:
		VariantType.normal:
			animated_sprite_2d.play("red")
		VariantType.elite:
			animated_sprite_2d.play("blue")
			lock_duration = 0.25
			target_duration = 0.25
			damage *= multiplier
