extends Enemy

func _ready():
	super()
	speed = 100

func _physics_process(delta: float):
	var target_pos: Vector2 = get_nearest_player()
	velocity = global_position.direction_to(target_pos) * speed
	move_and_slide()
