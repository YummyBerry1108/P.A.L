class_name ArcaneStackModifier extends SkillModifier

## 巫王帽帽的被動載體，同時也是這把武器所有可調數值的唯一來源。
##
## ArcaneStackComponent 會把「同一份」實例塞進玩家的每一個 SkillData，
## 所以：
##   on_post_hit -> 所有武器的每次打擊都追加一段魔法傷害
##   on_kill     -> 所有武器的擊殺都會疊層
## 技能樹只要升級帽帽這一份，其他武器身上的參照也同步更新。

@export var magic_damage_per_stack: float = 1.0
@export var stacks_per_kill: int = 1
@export var stacks_per_extra_circle: int = 60
@export var undying_drain_per_second: float = 60.0

## 獨立的第二段傷害，跟主傷害分開飄字，不吃主傷害的暴擊倍率
func on_post_hit(context: SkillContext) -> void:
	var component: ArcaneStackComponent = _get_component(context.source)
	if component == null:
		return

	var magic_damage: float = component.get_magic_damage()
	if magic_damage <= 0.0:
		return

	if not is_instance_valid(context.target):
		return

	var damage_component = context.target.get("damage_component")
	if damage_component == null:
		return

	damage_component.take_damage.rpc(magic_damage, false)

func on_kill(context: SkillContext) -> void:
	var component: ArcaneStackComponent = _get_component(context.source)
	if component == null:
		return
	component.add_stacks_for_kill()

func _get_component(source: Node) -> ArcaneStackComponent:
	if not is_instance_valid(source):
		return null
	return source.get_node_or_null("ArcaneStackComponent") as ArcaneStackComponent
