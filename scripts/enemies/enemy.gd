class_name Enemy extends CharacterBody2D

@export var texture: Texture2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var damage_number_position: Node2D = $DamageNumberPosition # Only for damage position
@onready var effect_component: EffectComponent = $EffectComponent
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer
#@onready var dev_info: Label = $DevInfo


var hp: float = 50
var speed: float = 100
var speed_multiplier: float = 1.0
var direction: Vector2 = Vector2.ZERO
var damage: float = 10.0

func _ready() -> void:
	if texture:
		sprite.texture = texture
		
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	velocity = direction * speed * delta * speed_multiplier
	move_and_slide()

func update_speed() -> void:
	speed_multiplier = effect_component.get_speed_multiplier()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	var projectile = area.owner as Projectile
	
	if projectile:
		take_damage(projectile.damage)
		
		for effect in projectile.status_effects:
			effect_component.add_effect(effect)
			
func take_damage(projectile_damage: float) -> void:
	DamageNumber.display_number(projectile_damage, damage_number_position.global_position, false)
	hp -= projectile_damage
	hit_flash_animation_player.play("hit_flash")
	#if dev_info:
		#dev_info.take_damage(projectile_damage)
	if hp <= 0:
		die()

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
