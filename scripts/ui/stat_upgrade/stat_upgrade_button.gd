extends Button

signal upgrade_selected(upgrade_id: String)

@export var title_label: Label
@export var desc_label: Label
@export var upgrade_icon: TextureRect
@export var card_image: TextureRect

var stat_id: String

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func setup(data: StatUpgradeData) -> void:
	stat_id = data.upgrade_id
	title_label.text = data.title
	desc_label.text = data.description
	upgrade_icon.texture = data.upgrade_icon
	card_image.texture = data.card_image
	
	var target_color: Color = StatUpgradeData.RARITY_COLORS[data.rarity]

func _on_button_pressed() -> void:
	UpgradeEventbus.stat_upgrade.emit(stat_id)
	upgrade_selected.emit(stat_id)
