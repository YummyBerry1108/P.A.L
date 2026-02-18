class_name Enemy extends CharacterBody2D

signal _on_enemy_died(enemy: Enemy)

@export var texture: Texture2D
@export var exp_orb_scene: Resource = preload("res://scenes/etc/exp_orb.tscn")
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
var exp_amount: int = 1

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
	if !multiplayer.is_server(): return
	var projectile = area.owner as Projectile
	var critical_hit: bool = false
	var result = 0.0
	
	if projectile:
		if randf() <= projectile.crit_chance:
			result = projectile.damage * projectile.crit_damage_multiplier
			critical_hit = true
		else:
			result = projectile.damage
		take_damage.rpc(result, critical_hit)
		
		for effect in projectile.status_effects:
			effect_component.add_effect(effect)
			
@rpc("any_peer", "call_local")
func take_damage(projectile_damage: float, critical_hit: bool) -> void:
	DamageNumber.display_number(projectile_damage, damage_number_position.global_position, critical_hit)
	hp -= projectile_damage
	hit_flash_animation_player.play("hit_flash")
	#if dev_info:
		#dev_info.take_damage(projectile_damage)
	if hp <= 0 and multiplayer.is_server():
		die()
		
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
