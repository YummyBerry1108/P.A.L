extends CharacterBody2D

@export var projectile: PackedScene
@export var fire_rate: int = 1

const SPEED: float = 500.0

var can_shoot: bool = true

func get_input(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED * delta * 60
	else:
		velocity = lerp(velocity, Vector2.ZERO, 1.0 * delta * 60)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()


func shoot():
	if can_shoot:
		can_shoot = false
		var new_projectile: Projectile = projectile.instantiate()
		new_projectile.position = global_position
		new_projectile.look_at(get_global_mouse_position())
		get_tree().root.call_deferred("add_child", new_projectile)
		await get_tree().create_timer(1 / fire_rate).timeout
		can_shoot = true
