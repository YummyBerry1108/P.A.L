class_name KnockbackComponent extends Node

@export var actor: Enemy
@export var hurt_box: Area2D
@export var knockback_resistance: float = 0.0
@export var behavior_tree_component: BehaviorTreeComponent

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func _ready() -> void:
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if !multiplayer.is_server(): return
	var projectile = area.owner as Projectile
	
	if not is_instance_valid(projectile) or not projectile.skill_data:
		return
	
	process_projectile_knockback(projectile)

func process_projectile_knockback(projectile: Projectile) -> void:
	var skill_data = projectile.skill_data
	
	var ctx = SkillContext.new(skill_data, projectile.actor)
	ctx.projectile = projectile
	ctx.target = actor
	ctx.knockback_force = skill_data.knockback_force
	ctx.knockback_duration = skill_data.knockback_duration
	if ctx.knockback_force <= 0.0:
		return

	var direction := Vector2.ZERO
	if projectile.velocity != Vector2.ZERO:
		direction = projectile.velocity.normalized()
	else:
		var diff := actor.global_position - projectile.global_position
		direction = diff.normalized() if diff != Vector2.ZERO else Vector2.RIGHT

	apply_knockback(ctx.knockback_force, direction, ctx.knockback_duration)

func apply_knockback(force: float, knockback_direction: Vector2, knockback_duration: float) -> void:
	knockback = force * knockback_direction * (1-knockback_resistance)
	knockback_timer = knockback_duration * (1-knockback_resistance)
	#print(knockback, knockback_timer)
	behavior_tree_component.change_behavior("knockback")
