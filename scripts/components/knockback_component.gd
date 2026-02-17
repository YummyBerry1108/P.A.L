class_name KnockbackComponent extends Node

@export var actor: Enemy
@export var hurt_box: Area2D
@export var knockback_resistance: float = 0.0

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func _ready() -> void:
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if !multiplayer.is_server(): return
	var projectile = area.owner as Projectile
	
	apply_knockback(projectile.knockback_force, projectile.velocity.normalized(), projectile.knockback_duration)

func apply_knockback(force: float, knockback_direction: Vector2, knockback_duration: float) -> void:
	knockback = force * knockback_direction * (1-knockback_resistance)
	knockback_timer = knockback_duration * (1-knockback_resistance)

func knockback_check(delta: float) -> bool:
	if knockback_timer > 0:
		if "current_state" in actor:
			actor.current_state = actor.State.IDLE
		actor.velocity = knockback
		knockback_timer -= delta
		return true
	return false
