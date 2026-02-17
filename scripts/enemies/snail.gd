extends Enemy

func _ready() -> void:
	super()
	speed = 100

func _physics_process(_delta: float) -> void:
	if !multiplayer.is_server(): return
	var target_pos: Vector2 = get_nearest_player()
	velocity = global_position.direction_to(target_pos) * speed * speed_multiplier
	move_and_slide()
