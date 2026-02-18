extends CharacterBody2D

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
	
	# not a really good method, but I didn't know how to modify
	var main = get_tree().root.get_node("Main")
	
	if main and main.has_method("add_experience"):
		main.add_experience(exp_amount)
		queue_free()
