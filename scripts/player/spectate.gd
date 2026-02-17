extends Node

var is_spectating: bool
var spectate_target: Player
var camera: Camera2D

func run(args: Dictionary) -> void:
	is_spectating = args["is_spectating"]
	spectate_target = args["spectate_target"]
	camera = args["camera"]
	_handle_input()

func _handle_input() -> void:
	if Input.is_action_just_pressed("shoot"):
		switch_to_next_player()

func switch_to_next_player() -> void:
	var alive_players: Array = _get_all_alive_players()
	if alive_players.size() == 0:
		return

	var next_index = 0
	if spectate_target in alive_players:
		var current_index = alive_players.find(spectate_target)
		next_index = (current_index + 1) % alive_players.size()
	_set_spectate_target(alive_players[next_index])

func _get_all_alive_players() -> Array:
	var candidates = []
	var all_players = get_tree().get_nodes_in_group("players")
	
	for p in all_players:
		if is_instance_valid(p) and p != self and p.is_alive:
			candidates.append(p)
			
	return candidates

func _set_spectate_target(target_node: Player) -> void:
	owner.spectate_target = target_node 
		
	if target_node.has_node("Camera2D"):
		target_node.get_node("Camera2D").make_current()
