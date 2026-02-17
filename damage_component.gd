class_name DamageComponent extends Node

@export var actor: Enemy
@export var effect_component: EffectComponent
@export var damage_number_position: Marker2D
@export var knockback_componet: KnockbackComponent
@export var hurt_box: Area2D

signal on_hit(damage: float)

func _ready() -> void:
	if hurt_box:
		hurt_box.area_entered.connect(_on_hurt_box_area_entered)

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
		
		if knockback_componet:
			knockback_componet.apply_knockback(projectile.knockback_force, projectile.velocity.normalized(), projectile.knockback_duration)
		
		for effect in projectile.status_effects:
			effect_component.add_effect(effect)
			
@rpc("any_peer", "call_local")
func take_damage(projectile_damage: float, critical_hit: bool) -> void:
	emit_signal("on_hit", projectile_damage)
	
	DamageNumber.display_number(projectile_damage, damage_number_position.global_position, critical_hit)
	actor.hp -= projectile_damage
	actor.hit_flash_animation_player.play("hit_flash")
	#if dev_info:
		#dev_info.take_damage(projectile_damage)
	if actor.hp <= 0 and multiplayer.is_server():
		actor.die()
