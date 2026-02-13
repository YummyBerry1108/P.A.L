extends Enemy

@export var max_speed: float = 400.0 * 60
@export var steer_force: float = 3.0 * 60

func _ready():
	super()

func _physics_process(delta: float):
	var target_pos: Vector2 = get_nearest_player()
	direction = global_position.direction_to(target_pos)
	var desired_velocity = direction * max_speed 
	var steering = (desired_velocity - velocity * 60).limit_length(steer_force)
	velocity += steering * delta
	move_and_slide()

	
