class_name SkillContext extends RefCounted

var source: Node                    # 發動者（玩家/怪物）
var skill_data: SkillData           # 觸發技能的 Data
var projectile: Node = null         # 產生的投射物（可為 null）
var target: Node = null             # 目標節點
var hit_count: int = 0              # 該攻擊已命中的目標數量
var base_damage: float = 0.0        # 基礎傷害
var final_damage: float = 0.0       # 經過所有 Modifier 結算後的傷害
var is_critical: bool = false       # 是否暴擊
var status_effects: Array[StatusEffectRes] = []
var knockback_force: float = 0.0
var knockback_duration: float = 0.0
var extra_data: Dictionary = {}     # 供特殊 Modifier 互相傳遞暫存資料

func _init(_skill_data: SkillData, _source: Node = null) -> void:
	skill_data = _skill_data
	source = _source
	if skill_data:
		base_damage = skill_data.projectile_damage
		final_damage = base_damage
		status_effects = skill_data.status_effects.duplicate()
		knockback_force = skill_data.knockback_force
		knockback_duration = skill_data.knockback_duration
