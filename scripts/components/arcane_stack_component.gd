class_name ArcaneStackComponent extends Node

## 巫王帽帽的堆疊 (X)。掛在 Player 底下。
## stacks 只由 server 改動，改完用 rpc 廣播給所有 peer，
## 因為 client 也要靠 stacks 算出一模一樣的圓形數量。

signal stacks_changed(stacks: int)

const SYNC_INTERVAL: float = 0.1

@export var source_skill_name: String = "witch_hat"

var stacks: float = 0.0
var is_undying: bool = false

var _config: ArcaneStackModifier = null
var _config_resolved: bool = false
var _sync_timer: float = 0.0

func _ready() -> void:
	# Player 的 _enter_tree 會把 authority 遞迴設成該玩家的 peer id，
	# 但這份狀態是 server 算的，所以要搶回來給 server。
	set_multiplayer_authority(1)
	set_process(multiplayer.is_server())
	call_deferred("_inject_into_all_skills")

## 把同一份 Modifier「參照」塞進這名玩家的每一個 SkillData。
## 因為是同一個 Resource 實例，技能樹升級帽帽這一份時，所有武器會同時吃到。
## 只在 server 做：on_kill / on_post_hit 這兩個 hook 本來就只在 server 觸發。
func _inject_into_all_skills() -> void:
	if not multiplayer.is_server():
		return
	var config: ArcaneStackModifier = get_config()
	if config == null:
		return
	for skill_name in _get_player().skills:
		var skill_data: SkillData = _get_player().skills[skill_name]
		if not skill_data.modifiers.has(config):
			skill_data.modifiers.append(config)

func get_config() -> ArcaneStackModifier:
	if _config_resolved:
		return _config
	var player: Player = _get_player()
	if player == null or not player.skills.has(source_skill_name):
		return null
	for mod in player.skills[source_skill_name].modifiers:
		if mod is ArcaneStackModifier:
			_config = mod
			break
	_config_resolved = true
	return _config

## 帽帽被 disable 時整套被動都不該生效
func is_active() -> bool:
	var player: Player = _get_player()
	if player == null or not player.skills.has(source_skill_name):
		return false
	return not player.skills[source_skill_name].disable

func get_stack_count() -> int:
	return int(floor(stacks))

func get_magic_damage() -> float:
	var config: ArcaneStackModifier = get_config()
	if config == null or not is_active():
		return 0.0
	return get_stack_count() * config.magic_damage_per_stack

## 每 stacks_per_extra_circle 層多一個圓
func get_extra_circle_count() -> int:
	var config: ArcaneStackModifier = get_config()
	if config == null or config.stacks_per_extra_circle <= 0:
		return 0
	return int(floor(float(get_stack_count()) / config.stacks_per_extra_circle))

func add_stacks_for_kill() -> void:
	if not multiplayer.is_server() or not is_active():
		return
	var config: ArcaneStackModifier = get_config()
	if config == null:
		return
	stacks += config.stacks_per_kill
	_broadcast()

## server 在送出致命傷害前呼叫。回傳 true 代表這一下被堆疊擋掉，HP 鎖在 1。
func try_absorb_lethal() -> bool:
	if not multiplayer.is_server() or not is_active():
		return false
	if stacks <= 0.0:
		return false
	is_undying = true
	return true

func _process(delta: float) -> void:
	if not is_undying:
		return
	var config: ArcaneStackModifier = get_config()
	var drain: float = config.undying_drain_per_second if config else 60.0
	stacks = max(stacks - drain * delta, 0.0)

	if stacks <= 0.0:
		is_undying = false
		_sync_timer = 0.0
		_broadcast()
		return

	_sync_timer += delta
	if _sync_timer >= SYNC_INTERVAL:
		_sync_timer = 0.0
		_broadcast()

func _broadcast() -> void:
	_sync_stacks.rpc(stacks, is_undying)

@rpc("authority", "call_local", "reliable")
func _sync_stacks(new_stacks: float, undying: bool) -> void:
	stacks = new_stacks
	is_undying = undying
	stacks_changed.emit(get_stack_count())

func _get_player() -> Player:
	return get_parent() as Player
