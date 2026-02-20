class_name Enemy extends CharacterBody2D

signal _on_enemy_died(enemy: Enemy)


var exp_orb_scene: Resource = preload("res://scenes/etc/exp_orb.tscn")
#@onready var dev_info: Label = $DevInfo

@export var texture: Texture2D
@export_category("Basic")
@export var hp: float = 50
@export var damage: float = 10.0
@onready var animated_sprite_2d: AnimatedSprite2D = get_node("AnimatedSprite2D")
#@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var hurt_box: Area2D = get_node("HurtBox")
@onready var effect_component: EffectComponent = get_node("EffectComponent")
@onready var hit_flash_animation_player: AnimationPlayer = get_node("HitFlashAnimationPlayer")
@onready var damage_component: DamageComponent = get_node("DamageComponent")
@onready var knockback_component: KnockbackComponent = get_node("KnockbackComponent")

#@onready var dev_info: Label = $DevInfo

var speed: float = 100
var speed_multiplier: float = 1.0
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var exp_amount: int = 1

func _ready() -> void:
	pass
	#if texture:
		#sprite.texture = texture
		
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	velocity = direction * speed * speed_multiplier

	move_and_slide()

func update_speed() -> void:
	speed_multiplier = effect_component.get_speed_multiplier()
		
## find player by group, return the nearest player's position
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
	_on_enemy_died.emit(self)
	queue_free()
