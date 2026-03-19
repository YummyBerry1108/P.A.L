extends Button

@onready var border: ReferenceRect = $ReferenceRect
var upgrade_id: String

func _ready() -> void:
	UpgradeEventbus.on_skill_unlocked.connect(_on_skill_unlocked)
	UpgradeEventbus.on_skill_active.connect(_on_skill_active)
	modulate.a = 0.1

func setup(uid: String) -> void:
	upgrade_id = uid
	
func _on_pressed() -> void:
	UpgradeEventbus.request_upgrade.emit(upgrade_id)

func _on_skill_unlocked(id: String) -> void:
	if upgrade_id == id:
		modulate.a = 1.0

func _on_skill_active(id: String) -> void:
	if upgrade_id == id:
		modulate.a = 1.0
		border.visible = true
