extends Button

signal upgrade_selected(upgrade_id: String)

@export var title_label: Label
@export var desc_label: Label

var current_upgrade_id: String

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func setup(id: String, title: String, desc: String) -> void:
	current_upgrade_id = id
	title_label.text = title
	desc_label.text = desc

func _on_button_pressed() -> void:
	upgrade_selected.emit(current_upgrade_id)
