extends CharacterBody2D

@onready var damage_number_position: Node2D = $DamageNumberPosition # Only for damage position
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer
@onready var effect_component: EffectComponent = $EffectComponent
@onready var dev_info: Label = $DevInfo
@onready var dps_timer: Timer = $DevInfo/DPSTimer

@export var knockback_resistance: float = 1.0
var speed: float = 100
var speed_multiplier: float = 1.0
var total_damage: float = 0.0

var damage_this_second: float = 0.0
var current_dps: float = 0.0
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if knockback_timer > 0:
		velocity = knockback
		knockback_timer -= delta
		move_and_slide()
		

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if !multiplayer.is_server(): return
	var projectile = area.owner as Projectile
	var damage: float = 0.0
	var critical_hit: bool = false
	
	if projectile:
		if randf() <= projectile.crit_chance:
			damage = projectile.damage * projectile.crit_damage_multiplier
			critical_hit = true
		else:
			damage = projectile.damage
		take_damage.rpc(damage, critical_hit)
		
		apply_knockback(projectile.knockback_force, projectile.velocity.normalized(), projectile.knockback_duration)
		
		
		for effect in projectile.status_effects:
			effect_component.add_effect(effect)

@rpc("any_peer", "call_local")
func take_damage(damage: float, critical_hit: bool) -> void:
	DamageNumber.display_number(damage, damage_number_position.global_position, critical_hit)
	hit_flash_animation_player.play("hit_flash")
	$DevInfo.take_damage(damage)

func apply_knockback(force: float, knockback_direction: Vector2, knockback_duration: float) -> void:
	knockback = force * knockback_direction * (1-knockback_resistance)
	knockback_timer = knockback_duration * (1-knockback_resistance)

func knockback_check(delta: float) -> void:
	if knockback_timer > 0:
		velocity = knockback * (1-knockback_resistance)
		knockback_timer -= delta

func update_speed() -> void:
	speed_multiplier = effect_component.get_speed_multiplier()
