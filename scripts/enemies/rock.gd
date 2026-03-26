extends Enemy

@export var max_speed: float = 400.0
@export var steer_force: float = 300.0

func _ready() -> void:
	super()

func _set_up_variant_stat() -> void:
	match variant_type:
		VariantType.normal:
			animated_sprite_2d.play("red")
		VariantType.elite:
			animated_sprite_2d.play("blue")
			steer_force *= 1.5
			max_speed *= 1.5
			damage *= multiplier
