class_name SkillData extends Node

@export var attack_type: String = "Single"
@export var projectile_type: String = "Normal"
@export var skill_name: String = "NULL"
@export var multishot: int = 1
@export var projectile_count: int = 1
@export var firerate: float = 1

@export_range(0, 360) var arc: float = 0
@export_range(0, 360) var arc_increment: float = 30
