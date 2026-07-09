extends Control
class_name UI
@export var exp_bar: ProgressBar
@export var exp_label: Label
@export var health_bar: ProgressBar
@export var time_label: Label
@export var pause_label: Label
@export var spectate_label: Label
@export var stat_upgrade_ui: Control
@export var skill_tree_ui: Control

func _ready() -> void:
	spectate_label.hide()

func update_timer_display(time_elapsed: float) -> void:
	if not multiplayer.is_server():
		return

	var minutes = floor(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func update_experience_display(current: int, max_val: int) -> void:
	exp_bar.max_value = max_val
	exp_bar.value = current

func update_level_display(level: int) -> void:
	exp_label.text = "Level: " + str(level)

func update_health_display(amount: int) -> void:
	health_bar._set_health(amount)

func update_max_health_display(max_hp: int) -> void:
	health_bar.init_health(max_hp)

func _update_spectate_display(new_text: String) -> void:
	spectate_label.text = "Spectating: " + new_text
	spectate_label.show()

func show_pause_waiting() -> void:
	pause_label.text = "Waiting for other player..."

func show_upgrades_by_level(level: int) -> void:
	if level % 5 == 0 and level <= 25:
		skill_tree_ui.show_upgrades.rpc()
	else:
		stat_upgrade_ui.show_upgrades.rpc()
