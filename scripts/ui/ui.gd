extends Control

@export var exp_bar: ProgressBar
@export var exp_label: Label
@export var health_bar: ProgressBar
@export var time_label: Label
@export var pause_label: Label
@export var spectate_label: Label
@export var stat_upgrade_container: HBoxContainer

func _ready() -> void:
	exp_bar._on_little_level_up.connect(stat_upgrade_container.show_upgrades)
	exp_bar._on_little_level_up.connect(pause_label._on_level_up)
