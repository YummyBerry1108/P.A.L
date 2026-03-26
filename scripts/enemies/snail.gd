extends Enemy

func _ready() -> void:
	super()
	speed = 100

func _set_up_variant_stat() -> void:
	match variant_type:
		VariantType.normal:
			animated_sprite_2d.play("red")
		VariantType.elite:
			animated_sprite_2d.play("blue")
			damage *= multiplier * 2
