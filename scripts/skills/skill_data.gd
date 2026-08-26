class_name SkillData extends Node

#ACTUAL NODE NAME DOES NOT MATTER FOR SKILL DATA NODES

signal skill_updated

@export_category("Basic")
@export var disable: bool = false
@export var projectile_type: String = "Normal"
@export var skill_name: String = "NULL"

@export_category("ShootingSetting")
@export var multishot: int = 1
@export var projectile_count: int = 1
@export var firerate: float = 1
@export_range(0, 360) var rotation_randomization: float = 0
@export_group("Arc")
@export_range(0, 360) var arc: float = 0
@export_range(0, 360) var arc_increment: float = 30

@export_category("ProjectileSetting")
@export var scale: float = 0.30
@export var projectile_damage: float = 10.0
@export var cooldown: float = 1.0
@export var status_effects: Array[StatusEffectRes] = []
@export_group("CriticalHitSetting")
@export_range(0.0, 1.0, 0.01) var crit_chance: float = 0
@export var crit_damage_multiplier: float = 2.0
@export_group("KnockbackSetting")
@export var knockback_force: float = 0.0
@export var knockback_duration: float = 0.0
@export_category("Custom Modifiers")
@export var modifiers: Array[SkillModifier] = []

var spawn_count: int = 0

func trigger_projectile_spawned(context: SkillContext) -> void:
	sync_property.rpc("spawn_count", spawn_count + 1)
	for mod in modifiers:
		if mod and mod.is_active:
			mod.on_projectile_spawned(context)

func trigger_pre_hit(context: SkillContext) -> void:
	for mod in modifiers:
		if mod and mod.is_active:
			mod.on_pre_hit(context)

func trigger_post_hit(context: SkillContext) -> void:
	for mod in modifiers:
		if mod and mod.is_active:
			mod.on_post_hit(context)

func trigger_projectile_expired(context: SkillContext) -> void:
	for mod in modifiers:
		if mod and mod.is_active:
			mod.on_projectile_expired(context)

func apply_upgrade(upgrade: SkillUpgrade) -> void:
	match upgrade.upgrade_type:
		SkillUpgrade.UpgradeType.ADD_MODIFIER:
			_apply_add_modifier(upgrade)
			
		SkillUpgrade.UpgradeType.ADD_STATUS_EFFECT:
			_apply_add_status_effect(upgrade)
			
		SkillUpgrade.UpgradeType.NUMERIC_STAT:
			_apply_numeric_stat(upgrade)

	skill_updated.emit()


func _apply_add_modifier(upgrade: SkillUpgrade) -> void:
	if not upgrade.modifier_to_add:
		push_warning("SkillUpgrade 未設定 modifier_to_add")
		return
		
	var new_mod = upgrade.modifier_to_add.duplicate(true)
	var existing_idx = -1
	for i in range(modifiers.size()):
		if modifiers[i] and modifiers[i].id == new_mod.id:
			existing_idx = i
			break
	if existing_idx != -1:
		modifiers[existing_idx] = new_mod
		if is_multiplayer_authority():
			print("[%s] 已覆寫/更新 Modifier: %s" % [skill_name, new_mod.id])
	else:
		modifiers.append(new_mod)
		if is_multiplayer_authority():
			print("[%s] 已新增 Modifier: %s" % [skill_name, new_mod.id])

func _apply_add_status_effect(upgrade: SkillUpgrade) -> void:
	if not upgrade.status_effect_to_add:
		push_warning("SkillUpgrade 未設定 status_effect_to_add")
		return
		
	var new_effect = upgrade.status_effect_to_add.duplicate(true)
	status_effects.append(new_effect)
	if is_multiplayer_authority():
		print("[%s] 已新增 StatusEffect: %s" % [skill_name, new_effect.resource_path])

func _apply_numeric_stat(upgrade: SkillUpgrade) -> void:
	var stat_str = upgrade.get_stat_name()
	var modified: bool = false
	
	if stat_str in self:
		var new_val = _calculate_new_value(self.get(stat_str), upgrade)
		self.set(stat_str, new_val)
		modified = true
		if is_multiplayer_authority():
			print("[%s] 自身屬性 %s 更新為: %s" % [skill_name, stat_str, new_val])
	
	for effect in status_effects:
		if effect and stat_str in effect:
			var new_val = _calculate_new_value(effect.get(stat_str), upgrade)
			effect.set(stat_str, new_val)
			modified = true
			if is_multiplayer_authority():
				print("[%s] StatusEffect 屬性 %s 更新為: %s" % [skill_name, stat_str, new_val])

	for mod in modifiers:
		if mod and stat_str in mod:
			var new_val = _calculate_new_value(mod.get(stat_str), upgrade)
			mod.set(stat_str, new_val)
			modified = true
			if is_multiplayer_authority():
				print("[%s] Modifier [%s] 屬性 %s 更新為: %s" % [skill_name, mod.id, stat_str, new_val])

	if not modified:
		push_warning("[%s] 找不到變數 %s 無法套用數值升級" % [skill_name, stat_str])


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

@rpc("any_peer", "call_local", "reliable")
func sync_property(property: StringName, value: Variant) -> void:
	set(property, value)
