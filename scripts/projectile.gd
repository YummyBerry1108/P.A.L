class_name Projectile
extends CharacterBody2D

@onready var hitbox: Area2D

@export var initial_speed: float = 240.0
@export var target_speed: float = 240.0
@export var acceleration: float = 0.0
@export var lifespan: float = 1.0

var speed: float = initial_speed
var diraction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	diraction = Vector2.RIGHT.rotated(global_rotation)
	
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_aera_entered)

	await get_tree().create_timer(lifespan).timeout
	_before_lifespan_expired()

	queue_free()

func _physics_process(delta: float) -> void:
	speed = lerp(speed, target_speed, acceleration * delta)
	velocity = diraction * speed * delta

	var collision: bool = move_and_slide()
	if collision:
		queue_free()
	
func _before_lifespan_expired() -> void:
	pass
	
func _on_hurt_box_aera_entered(area: Area2D) -> void:
	pass
