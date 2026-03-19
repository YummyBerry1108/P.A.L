extends Button

signal upgrade_selected(upgrade_id: String)

@export var title_label: Label
@export var desc_label: Label

var current_upgrade_id: String

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func setup(data: StatUpgradeData) -> void:
	current_upgrade_id = data.upgrade_id
	title_label.text = data.title
	desc_label.text = data.description
	
	var target_color: Color = StatUpgradeData.RARITY_COLORS[data.rarity]
	
	var normal_style = StyleBoxFlat.new()
	normal_style.border_color = target_color
	normal_style.set_border_width_all(6)
	normal_style.bg_color = "24221e"
	add_theme_stylebox_override("normal", normal_style)
	
	var hover_style = normal_style.duplicate()
	hover_style.border_color = target_color.lightened(0.2)
	hover_style.set_border_width_all(6)
	hover_style.bg_color = "24221e"
	add_theme_stylebox_override("hover", hover_style)

func _on_button_pressed() -> void:
	upgrade_selected.emit(current_upgrade_id)
