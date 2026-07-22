extends Node
class_name SkillUpgradeManager

func show_upgrades() -> void:
	UpgradeEventbus.show_skill_upgrades.emit()
	
func apply_upgrades() -> void:
	pass
