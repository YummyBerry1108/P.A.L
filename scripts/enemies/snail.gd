extends Enemy

func _ready() -> void:
	speed = 100
	super()

func _set_up_variant_stat() -> void:
	match variant_type:
		VariantType.normal:
			hp *= multiplier
			animated_sprite_2d.play("red")
		VariantType.elite:
			hp *= multiplier * 10.0
			animated_sprite_2d.play("blue")
			damage *= multiplier * 2
			speed *= player_speed_ref/speed
