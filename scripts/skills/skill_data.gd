class_name SkillData extends Node

#ACTUAL NODE NAME DOES NOT MATTER FOR SKILL DATA NODES

signal skill_updated

@export_category("Basic")
@export var disable: bool = false
@export var projectile_type: String = "Normal"
@export var skill_name: String = "NULL"
@export var shooter_id: int = 0

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
@export var cooldown: float = 1.0
@export var status_effects: Array[StatusEffectRes] = []
@export_group("CriticalHitSetting")
@export_range(0.0, 1.0, 0.01) var crit_chance: float = 0
@export var crit_damage_multiplier: float = 2.0
@export_group("KnockbackSetting")
@export var knockback_force: float = 0.0
@export var knockback_duration: float = 0.0

func apply_upgrade(effect: SkillUpgrade) -> void:
	var stat_name = effect.get_stat_name()
	if stat_name in self:
		var new_val = _calculate_new_value(self.get(stat_name), effect)
		self.set(stat_name, new_val)
		skill_updated.emit()
		
		if is_multiplayer_authority():
			print("已將 %s 的 %s 修改為 %s" % [skill_name, stat_name, new_val])
		return
		
	var updated_status_effect: bool = false
	for status_effect in status_effects:
		if status_effect and stat_name in status_effect:
			var new_val = _calculate_new_value(status_effect.get(stat_name), effect)
			status_effect.set(stat_name, new_val)
			updated_status_effect = true

	if updated_status_effect:
		skill_updated.emit()
		if is_multiplayer_authority():
			print("已更新 %s 的 StatusEffect 屬性: %s" % [skill_name, stat_name])
	else:
		push_warning("SkillData 與 StatusEffects 中均找不到變數: " + stat_name)

func _calculate_new_value(current_value, effect: SkillUpgrade):
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
		
	return new_value
