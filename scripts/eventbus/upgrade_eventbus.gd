extends Node
# Autoload named UpgradeEventbus
signal local_manager_ready(manager_instance: SkillTreeManager)

signal show_stat_upgrades(options: Array[StatUpgradeData]) # connected to stat upgrade ui
signal stat_upgrade_selected(upgrade_id: String) # connected to stat upgrade manager

signal show_skill_upgrades()
signal skill_upgrade(skill_id: String)
signal on_skill_unlocked(skill_id: String)
signal on_skill_active(skill_id: String)
