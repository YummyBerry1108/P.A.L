extends CharacterBody2D

@onready var damage_number_position: Node2D = $DamageNumberPosition # Only for damage position
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer
@onready var effect_component: EffectComponent = $EffectComponent
@onready var dev_info: Label = $DevInfo
@onready var dps_timer: Timer = $DevInfo/DPSTimer

var speed: float = 100
var speed_multiplier: float = 1.0
var total_damage: float = 0.0

var damage_this_second: float = 0.0
var current_dps: float = 0.0

signal taken_damage(damage: int)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_hurt_box_area_entered(area: Area2D) -> void:
	var projectile = area.owner as Projectile

	if projectile:
		take_damage(projectile.damage)
		
		for effect in projectile.status_effects:
			effect_component.add_effect(effect)

func take_damage(damage: float) -> void:
	emit_signal("taken_damage", damage)
	DamageNumber.display_number(damage, damage_number_position.global_position, false)
	hit_flash_animation_player.play("hit_flash")
	$DevInfo.take_damage(damage)

func update_speed() -> void:
	speed_multiplier = effect_component.get_speed_multiplier()
