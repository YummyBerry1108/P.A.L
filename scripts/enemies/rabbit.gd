extends Enemy

enum State { TARGET, LOCK_ON, DASH, CHASE , ROOT , IDLE}
var current_state = State.LOCK_ON

@export var dash_speed: float = 900.0
@export var target_duration: float = 0.5
@export var lock_duration: float = 0.5 
@export var dash_duration: float = 1
@export var jump_duration: float = 0.5
@export var idle_duration: float = 0.5

func _ready() -> void:
	super()
	if texture:
		sprite.texture = texture
	speed = 250
	_start_root_phase()

func _physics_process(delta: float) -> void:
	match current_state:
		State.CHASE:
			velocity = direction * speed * speed_multiplier
		State.IDLE:
			velocity = Vector2.ZERO
		State.DASH:
			velocity = direction * dash_speed * speed_multiplier
	move_and_slide()

func _start_root_phase() -> void:
	current_state = State.ROOT
	set_collision_mask_value(PhysicsLayers.ENEMY, true)
	set_collision_layer_value(PhysicsLayers.ENEMY, true)
	
	var dist = global_position.distance_to(get_nearest_player())
	
	if dist <= 400:
		_start_target_phase()
	else:
		_start_chase_phase()
	
func _start_chase_phase() -> void:
	current_state = State.CHASE
	
	var target_pos: Vector2 = get_nearest_player()
	direction = global_position.direction_to(target_pos)
	
	await get_tree().create_timer(jump_duration).timeout
	
	_start_idle_phase()

func _start_idle_phase() -> void:
	current_state = State.IDLE
	
	await get_tree().create_timer(idle_duration).timeout
	
	_start_root_phase()

func _start_target_phase() -> void:
	current_state = State.TARGET
	
	velocity = Vector2.ZERO
	
	await get_tree().create_timer(lock_duration).timeout
	
	_start_lock_on_phase()

func _start_lock_on_phase() -> void:
	
	current_state = State.LOCK_ON
	
	var target_pos: Vector2 = get_nearest_player()
	direction = global_position.direction_to(target_pos)
	await get_tree().create_timer(lock_duration).timeout
	
	_start_dash_phase()

func _start_dash_phase() -> void:
	current_state = State.DASH
	set_collision_mask_value(PhysicsLayers.ENEMY, false)
	set_collision_layer_value(PhysicsLayers.ENEMY, false)
	
	await get_tree().create_timer(dash_duration).timeout
	
	_start_idle_phase()
