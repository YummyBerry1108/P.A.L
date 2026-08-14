extends Resource
class_name SkillUpgrade
enum UpgradeType {
	NUMERIC_STAT,       # 修改數值（SkillData 或現有 Modifier/StatusEffect）
	ADD_MODIFIER,       # 新增行為組件 (SkillModifier)
	ADD_STATUS_EFFECT   # 新增狀態效果 (StatusEffectRes)
}
enum OpType { ADD, MULTIPLY, OVERRIDE } 
enum StatType {
	NONE,
	PROJECTILE_DAMAGE,
	FIRERATE,
	PROJECTILE_COUNT,
	SCALE,
	CRIT_CHANCE,
	CRIT_DAMAGE_MULTIPLIER,
	KNOCKBACK_FORCE,
	# Status Effect 相關
	POISON_DAMAGE,
	SLOW_RATIO,
	LIFE_STEAL_RATIO,
	SPEED_UP
}
@export_category("Upgrade Type")
@export var upgrade_type: UpgradeType = UpgradeType.NUMERIC_STAT
@export_category("Numeric Settings")
@export var stat_name: StatType
@export var operation: OpType = OpType.ADD
@export var value: float = 0.0
@export_category("Modifier Settings")
@export var modifier_to_add: SkillModifier
@export_category("Status Effect Settings")
@export var status_effect_to_add: StatusEffectRes

func get_stat_name() -> String:
	match stat_name:
		StatType.PROJECTILE_DAMAGE: return "projectile_damage"
		StatType.FIRERATE: return "firerate"
		StatType.PROJECTILE_COUNT: return "projectile_count"
		StatType.SCALE: return "scale"
		StatType.CRIT_CHANCE: return "crit_chance"
		StatType.CRIT_DAMAGE_MULTIPLIER: return "crit_damage_multiplier"
		StatType.KNOCKBACK_FORCE: return "knockback_force"
		StatType.POISON_DAMAGE: return "poison_damage"
		StatType.SLOW_RATIO: return "speed_multiplier"
		StatType.LIFE_STEAL_RATIO: return "lifesteal_rate"
		StatType.SPEED_UP: return "speed_multiplier"
	return ""
