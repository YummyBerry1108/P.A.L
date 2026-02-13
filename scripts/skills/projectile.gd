class_name Projectile
extends CharacterBody2D

@onready var hitbox: Area2D = $Hitbox

@export var initial_speed: float = 240.0
@export var target_speed: float = 240.0
@export var acceleration: float = 0.0
@export var lifespan: float = 1.0
@export var firerate: float = 1.0
@export var damage: float = 0.0
@export_range(0, 360) var arc: float = 0
@export_range(0, 360) var arc_increment: float = 30

var speed: float = 0.0
var diraction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	speed = initial_speed
	diraction = Vector2.RIGHT.rotated(global_rotation)
	
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_aera_entered)

	await get_tree().create_timer(lifespan).timeout
	_before_lifespan_expired()

	queue_free()

func _physics_process(delta: float) -> void:
	speed = lerp(speed, target_speed, acceleration)
	velocity = diraction * speed * delta * 60

	var collision: bool = move_and_slide()
	if collision:
		queue_free()
	
func _before_lifespan_expired() -> void:
	pass
	
func _on_hurt_box_aera_entered(area: Area2D) -> void:
	pass
