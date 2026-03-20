extends Node
# Autoload named UpgradeEventbus
signal local_manager_ready(manager_instance: SkillTreeManager)

signal request_upgrade(skill_id: String)

signal on_skill_unlocked(skill_id: String)
signal on_skill_active(skill_id: String)
