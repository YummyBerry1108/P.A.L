extends Node
class_name UpgradeManager

signal experience_changed(current_exp: int, max_exp: int)
signal level_changed(new_level: int)
signal upgrade_started

@export var stat_upgrade_manager: StatUpgradeManager
@export var skill_upgrade_manager: SkillUpgradeManager

var experience: int = 0
var experience_cap: int = 5
var level: int = 0

func add_experience(exp_value: int) -> void:
	if not multiplayer.is_server():
		return

	while exp_value > 0:
		if experience + exp_value > experience_cap:
			exp_value = experience + exp_value - experience_cap
			experience = experience_cap
		else:
			experience += exp_value
			exp_value = 0
		
		if experience == experience_cap:
			_level_up()

	experience_changed.emit(experience, experience_cap)

func _level_up() -> void:
	level += 1
	experience_cap = int(experience_cap * 1.1 + 1)
	experience = 0
	
	GameManager.change_pause_state.rpc(true)
	
	level_changed.emit(level)
	upgrade_started.emit()
	choose_upgrade_manager()

func choose_upgrade_manager() -> void:
	if level % 5 == 0 and level <= 25:
		skill_upgrade_manager.show_upgrade()
	else:
		stat_upgrade_manager.show_upgrades()
