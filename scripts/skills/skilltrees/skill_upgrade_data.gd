extends Resource
class_name SkillUpgrade

enum OpType { ADD, MULTIPLY, OVERRIDE } 
enum StatType {
	PROJECTILE_DAMAGE,
	FIRERATE,
	PROJECTILE_COUNT,
	SCALE,
	CRIT_CHANCE,
	CRIT_DAMAGE_MULTIPLIER,
	KNOCKBACK_FORCE,
	# Status Effect 相關
	POISON_DAMAGE,
	SLOW_RATIO
}

@export_category("Upgrade Settings")
@export var stat_name: StatType
@export var operation: OpType = OpType.ADD
@export var value: float = 0.0

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
	return ""
