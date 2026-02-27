extends CharacterBody2D

signal collected(exp_amount: int)

@onready var hurt_box: Area2D = $HurtBox

var exp_amount: int = 1

func _ready() -> void:
	pass

func _on_hurt_box_area_entered(area: Area2D) -> void:
	var player: Player = area.owner
	
	if not multiplayer.is_server():
		return
	if not player.is_in_group("players"):
		return
	
	collected.emit(exp_amount)
	queue_free()
