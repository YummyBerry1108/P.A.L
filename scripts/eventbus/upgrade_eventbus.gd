extends Node
# Autoload named UpgradeEventbus
signal request_upgrade(upgrade_id)

signal on_skill_unlocked(upgrade_id: String)
signal on_skill_active(upgrade_id: String)
