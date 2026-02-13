extends Projectile

func _ready() -> void:
	super._ready()
	
func _physics_process(delta: float) -> void:
	speed = lerp(speed, target_speed, acceleration * delta * 60)
	velocity = diraction * speed * delta * 60

	var collision: bool = move_and_slide()
