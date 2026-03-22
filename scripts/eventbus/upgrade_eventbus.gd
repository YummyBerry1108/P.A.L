extends Node
# Autoload named UpgradeEventbus
signal local_manager_ready(manager_instance: SkillTreeManager)
signal local_stat_upgrade_ready(manager_instance: StatUpgradeManager)

signal skill_upgrade(skill_id: String)
signal stat_upgrade(stat_id: String)

signal on_skill_unlocked(skill_id: String)
signal on_skill_active(skill_id: String)
