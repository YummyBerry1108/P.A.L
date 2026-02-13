class_name Player extends CharacterBody2D

signal health_changed(health: float)

@onready var hurt_box: Area2D = $HurtBox
@onready var invincibility_timer: Timer = $HurtBox/InvincibilityTimer

@export var projectile: PackedScene
@export var damage: float = 10.0
@export var hp: float = 100.0
@export var is_invincible: bool = false

const SPEED: float = 300.0
var skills: Dictionary = {}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pull_skills()
	fetch_behavior("Attack", { "player": self, "skills": skills })

func _physics_process(delta: float) -> void:
	fetch_behavior("Movement", { "player": self, "SPEED": SPEED, "delta": delta })
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if is_invincible:
		return 
	
	var enemy_root: Node = area.owner
	var enemy_damage: float = 0.0
	if enemy_root:
		enemy_damage = enemy_root.damage
		
	hp -= enemy_damage
	health_changed.emit(hp)
	is_invincible = true
	invincibility_timer.start()
	
func _on_timer_timeout():
	is_invincible = false
	var overlapping_areas = hurt_box.get_overlapping_areas()
	if overlapping_areas.is_empty():
		return
	else:
		_on_hurt_box_area_entered(overlapping_areas[0])
		
func fetch_behavior(name: String, args):
	get_node_or_null("Behaviors/" + name).run(args)

func pull_skills():
	for child: SkillData in get_node("Skills").get_children():
		skills[child.skill_name] = child
