extends Enemy


func _ready() -> void:
	super()

func _set_up_variant_stat() -> void:
	match variant_type:
		VariantType.normal:
			exp_amount *= floor(multiplier)
			hp *= multiplier
			animated_sprite_2d.play("red")
		VariantType.elite:
			exp_amount *= floor(multiplier) * 5
			hp *= multiplier * 10.0
			animated_sprite_2d.play("blue")
			damage *= multiplier * 2
			speed *= speed_multiplier_ref
