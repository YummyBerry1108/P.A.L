class_name SkillData extends Node

#ACTUAL NODE NAME DOES NOT MATTER FOR SKILL DATA NODES

@export_category("Basic")
@export var disable: bool = false
@export var projectile_type: String = "Normal"
@export var skill_name: String = "NULL"

@export_category("ShootingSetting")
@export var scale: float = 0.30
@export var multishot: int = 1
@export var projectile_count: int = 1
@export var firerate: float = 1
@export_range(0, 360) var rotation_randomization: float = 0
@export_group("Arc")
@export_range(0, 360) var arc: float = 0
@export_range(0, 360) var arc_increment: float = 30

@export_category("ProjectileSetting")
@export var projectile_damage: float = 10.0
@export var status_effects: Array[StatusEffectRes] = []
@export_group("CriticalHitSetting")
@export_range(0.0, 1.0, 0.01) var crit_chance: float = 0
@export var crit_damage_multiplier: float = 2.0
@export_group("KnockbackSetting")
@export var knockback_force: float = 0.0
@export var knockback_duration: float = 0.0

func apply_upgrade(effect: SkillUpgrade) -> void:
	if effect.stat_name in self:

		var current_value = self.get(effect.stat_name)
		var new_value = current_value
		
		match effect.operation:
			SkillUpgrade.OpType.ADD:
				new_value += effect.value
			SkillUpgrade.OpType.MULTIPLY:
				new_value *= effect.value
			SkillUpgrade.OpType.OVERRIDE:
				new_value = effect.value
				
		if typeof(current_value) == TYPE_INT:
			new_value = int(new_value)
			
		self.set(effect.stat_name, new_value)
		#if is_multiplayer_authority():
			#print("已將 %s 的 %s 從 %s 修改為 %s" % [skill_name, effect.stat_name, current_value, new_value])
	else:
		push_warning("SkillData 中找不到變數: " + effect.stat_name)
