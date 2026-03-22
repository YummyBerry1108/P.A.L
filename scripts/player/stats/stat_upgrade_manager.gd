extends Node
class_name StatUpgradeManager

func _ready() -> void:
	if not is_multiplayer_authority():
		return
	call_deferred("_announce_to_ui")

func _announce_to_ui() -> void:
	if is_multiplayer_authority():
		UpgradeEventbus.local_stat_upgrade_ready.emit(self)
