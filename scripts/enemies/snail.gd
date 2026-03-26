extends Enemy

func _ready() -> void:
	speed = 100
	super()

func _set_up_variant_stat() -> void:
	match variant_type:
		VariantType.normal:
			animated_sprite_2d.play("red")
		VariantType.elite:
			animated_sprite_2d.play("blue")
			#speed *= multiplier
			damage *= multiplier * 2
