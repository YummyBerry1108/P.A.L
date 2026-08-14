class_name DamageComponent extends Node

@export var actor: Enemy
@export var effect_component: EffectComponent
@export var damage_number_position: Marker2D
@export var hurt_box: Area2D

signal on_hit(damage: float)

func _ready() -> void:
	if hurt_box:
		hurt_box.area_entered.connect(_on_hurt_box_area_entered)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if not multiplayer.is_server(): return
	var projectile = area.owner as Projectile
	process_projectile_hit(projectile)
	
func process_projectile_hit(projectile: Projectile) -> void:
	if not multiplayer.is_server() or projectile == null: return
	var skill_data = projectile.skill_data
	projectile.hit_count += 1
	
	var hit_ctx = SkillContext.new(skill_data, projectile.actor)
	hit_ctx.projectile = projectile
	hit_ctx.target = actor
	hit_ctx.hit_count = projectile.hit_count
	hit_ctx.base_damage = projectile.damage
	hit_ctx.final_damage = projectile.damage
	if randf() <= skill_data.crit_chance:
		hit_ctx.is_critical = true
		hit_ctx.final_damage *= skill_data.crit_damage_multiplier

	skill_data.trigger_pre_hit(hit_ctx)
	
	take_damage.rpc(hit_ctx.final_damage, hit_ctx.is_critical)
	for effect in hit_ctx.status_effects:
		effect_component.add_effect(effect)
		
	skill_data.trigger_post_hit(hit_ctx)
			
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
