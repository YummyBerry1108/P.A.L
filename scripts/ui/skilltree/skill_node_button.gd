extends Button

signal upgrade_selected

@onready var border: ReferenceRect = $ReferenceRect
var skill_id: String
var manager_ref: SkillTreeManager # only for check node status, don't change anything in this

func _ready() -> void:
	UpgradeEventbus.on_skill_unlocked.connect(_on_skill_unlocked)
	UpgradeEventbus.on_skill_active.connect(_on_skill_active)
	modulate.a = 0.3
	
func setup(uid: String, manager: SkillTreeManager) -> void:
	skill_id = uid
	manager_ref = manager
	update_visuals()
	
func _on_pressed() -> void:
	if manager_ref.is_node_active(skill_id) or not manager_ref.is_node_unlocked(skill_id):
		return
	UpgradeEventbus.request_upgrade.emit(skill_id)
	upgrade_selected.emit()

func _on_skill_unlocked(id: String) -> void:
	update_visuals()

func _on_skill_active(id: String) -> void:
	update_visuals()

func update_visuals() -> void:
	if manager_ref == null: return
	
	if manager_ref.is_node_active(skill_id):
		modulate.a = 1.0
		border.visible = true 
	elif manager_ref.is_node_unlocked(skill_id):
		modulate.a = 1.0
		border.visible = false
	else:
		modulate.a = 0.3
		border.visible = false
