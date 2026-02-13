extends Projectile

func _physics_process(delta: float) -> void:
	speed = lerp(speed, target_speed, acceleration * delta)
	velocity = direction * speed

	move_and_slide()
