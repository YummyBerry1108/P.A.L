extends Enemy

@export var max_speed: float = 400.0
@export var steer_force: float = 300.0

func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	var target_pos: Vector2 = get_nearest_player()
	direction = global_position.direction_to(target_pos)
	var desired_velocity = direction * max_speed * speed_multiplier
	var steering = (desired_velocity - velocity).limit_length(steer_force)
	velocity += steering * delta
	move_and_slide()

	
