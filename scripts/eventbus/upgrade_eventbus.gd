extends Node
# Autoload named UpgradeEventbus
signal request_upgrade(skill_id)

signal on_skill_unlocked(skill_id: String)
signal on_skill_active(skill_id: String)
