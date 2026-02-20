extends Enemy

enum State { TARGET, LOCK_ON, DASH, CHASE , ROOT , IDLE}
var current_state = State.ROOT

@onready var state_timer: Timer = $StateTimer

@export var dash_speed: float = 900.0
@export var target_duration: float = 0.5
@export var lock_duration: float = 0.5 
@export var dash_duration: float = 1
@export var jump_duration: float = 0.5
@export var idle_duration: float = 0.5


func _ready() -> void:
	super()
	speed = 250
	if !multiplayer.is_server(): return
	state_timer.one_shot = true
	_start_root_phase()

func _physics_process(delta: float) -> void:
	if !multiplayer.is_server(): return
	match current_state:
		State.CHASE:
			velocity = direction * speed * speed_multiplier
		State.IDLE:
			velocity = Vector2.ZERO
		State.DASH:
			velocity = direction * dash_speed * speed_multiplier
	
	if knockback_timer > 0:
		current_state = State.IDLE
		velocity = knockback
		knockback_timer -= delta
	
	knockback_component.knockback_check(delta)
	move_and_slide()

func _start_state_timer(duration: float, next_phase: Callable) -> void:
	for conn in state_timer.timeout.get_connections():
		state_timer.timeout.disconnect(conn.callable)
		
	state_timer.timeout.connect(next_phase)
	state_timer.start(duration)

func _start_root_phase() -> void:
	current_state = State.ROOT
	set_collision_mask_value(PhysicsLayers.ENEMY, true)
	set_collision_layer_value(PhysicsLayers.ENEMY, true)
	
	var dist = global_position.distance_to(get_nearest_player())
	
	if dist <= 500:
		_start_target_phase()
	else:
		_start_chase_phase()
	
func _start_chase_phase() -> void:
	current_state = State.CHASE
	
	var target_pos: Vector2 = get_nearest_player()
	direction = global_position.direction_to(target_pos)
	
	_start_state_timer(idle_duration, _start_root_phase)

func _start_idle_phase() -> void:
	current_state = State.IDLE
	
	await get_tree().create_timer(idle_duration).timeout
	
	_start_state_timer(idle_duration, _start_root_phase)

func _start_target_phase() -> void:
	current_state = State.TARGET
	
	velocity = Vector2.ZERO
	
	_start_state_timer(lock_duration, _start_lock_on_phase)

func _start_lock_on_phase() -> void:
	
	current_state = State.LOCK_ON
	
	var target_pos: Vector2 = get_nearest_player()
	direction = global_position.direction_to(target_pos)
	
	_start_state_timer(lock_duration, _start_dash_phase)

func _start_dash_phase() -> void:
	current_state = State.DASH
	set_collision_mask_value(PhysicsLayers.ENEMY, false)
	set_collision_layer_value(PhysicsLayers.ENEMY, false)
	
	_start_state_timer(dash_duration, _start_idle_phase)
