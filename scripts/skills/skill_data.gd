class_name SkillData extends Node

@export_category("Basic")
@export var attack_type: String = "Single"
@export var projectile_type: String = "Normal"
@export var skill_name: String = "NULL"

@export_category("ShootingSetting")
@export var multishot: int = 1
@export var projectile_count: int = 1
@export var firerate: float = 1
@export_group("Arc")
@export_range(0, 360) var arc: float = 0
@export_range(0, 360) var arc_increment: float = 30

@export_category("ProjectileSetting")
@export var poojectile_damage: float = 10.0
@export var status_effects: Array[StatusEffectRes] = []
@export_group("CriticalHitSetting")
@export_range(0.0, 1.0, 0.01) var crit_chance: float = 0
@export var crit_damage_multiplier: float = 2.0
