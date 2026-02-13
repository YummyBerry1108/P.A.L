class_name Enemy extends CharacterBody2D

@export var texture: Texture2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var damage_number_position: Node2D = $DamageNumberPosition # Only for damage position

var hp: float = 50
var speed: float = 100 * 60
var direction: Vector2 = Vector2.ZERO
var damage: float = 10.0

func _ready():
	if texture:
		sprite.texture = texture
		
func _physics_process(delta: float):
	velocity = direction * speed * delta
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	var projectile_root: Node = area.owner
	var player_damage: float = 0.0 
	
	if projectile_root:
		player_damage = projectile_root.damage
		
	DamageNumber.display_number(player_damage, damage_number_position.global_position, false)
	hp -= player_damage
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
	var min_distance: float = INF
	var res: Vector2 = Vector2.ZERO
	var players = get_tree().get_nodes_in_group("players")
	
	for player in players:
		var player_pos : Vector2 = player.global_position
		var distance : float = global_position.distance_to(player_pos)
		if distance < min_distance:
			min_distance = distance
			res = player_pos
	
	return res

func die() -> void:
	queue_free()
