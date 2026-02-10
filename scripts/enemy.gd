class_name Enemy extends CharacterBody2D

@export var texture: Texture2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: CollisionShape2D = $HitBox
@onready var hurtbox: CollisionShape2D = $HurtBox

var hp: float = 100
var speed: float = 100
var direction: Vector2 = Vector2.ZERO

func _ready():
	if texture:
		sprite.texture = texture
		resize_to(300, 300)
		
func _physics_process(delta: float):
	velocity = direction * speed
	move_and_slide()

func resize_to(target_width: float, target_height: float) -> void:
	if texture:
		var original_size = texture.get_size()
		
		var scale_x = target_width / original_size.x
		var scale_y = target_height / original_size.y
		
		scale = Vector2(scale_x, scale_y)

func get_nearest_player() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	return mouse_pos

func taken_damage(damage: float) -> void:
	hp -= damage
	if hp <= 0:
		die()

func die() -> void:
	queue_free()
