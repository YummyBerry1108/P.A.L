extends Node
class_name UpgradeManager

@export var stat_upgrade_manager: StatUpgradeManager
@export var skill_upgrade_manager: SkillUpgradeManager


func level_up(level: int) -> void:
	choose_upgrade_manager(level)

func choose_upgrade_manager(level: int) -> void:
	if level % 5 == 0 and level <= 25:
		skill_upgrade_manager.show_upgrade()
	else:
		stat_upgrade_manager.show_upgrades()
