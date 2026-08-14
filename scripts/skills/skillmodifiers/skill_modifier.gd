class_name SkillModifier extends Resource

@export var is_active: bool = true
var id: String = ""

func _init() -> void:
	id = get_script().get_global_name()

# 1. 射擊前：修改發射參數（例如：彈道數量、散佈、冷卻）
func on_before_shoot(context: SkillContext) -> void:
	pass

# 2. 射擊產生投射物時：掛載屬性或特殊行為給 Projectile
func on_projectile_spawned(context: SkillContext) -> void:
	pass

# 3. 命中計算前：修改傷害數值或命中判定（例如：單體增傷、背刺加成）
func on_pre_damage(context: SkillContext) -> void:
	pass

# 4. 命中確認後：觸發次級效果（例如：爆炸、連鎖閃電、偷血、上狀態）
func on_post_hit(context: SkillContext) -> void:
	pass

# 5. 擊殺目標時：
func on_kill(context: SkillContext) -> void:
	pass

func on_projectile_expired(context: SkillContext) -> void:
	pass
