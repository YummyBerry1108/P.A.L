class_name Enemy extends CharacterBody2D

@export var texture: Texture2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var damage_number_position: Node2D = $DamageNumberPosition # Only for damage position

var hp: float = 100
var speed: float = 100
var direction: Vector2 = Vector2.ZERO

func _ready():
	if texture:
		sprite.texture = texture
		
func _physics_process(delta: float):
	velocity = direction * speed * delta
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	var damage = 10.0
	hp -= damage
	DamageNumber.display_number(damage, damage_number_position.global_position, false)
	if hp <= 0:
		die()
	$HitFlashAnimationPlayer.play("hit_flash")

func resize_to(target_width: float, target_height: float) -> void:
	if texture:
		var original_size = texture.get_size()
		
		var scale_x = target_width / original_size.x
		var scale_y = target_height / original_size.y
		
		scale = Vector2(scale_x, scale_y)

func get_nearest_player() -> Vector2:
	var players = get_tree().get_nodes_in_group("players")
	var player_pos = players[0].global_position
	return player_pos

func die() -> void:
	queue_free()
