extends Node

var indicators_pool: Array[Node2D] = []
var is_ready: bool = false
var other_players: Array[Player]

func _ready() -> void:
	if not is_multiplayer_authority(): return
	Lobby.all_player_ready.connect(set_indicators)

func set_indicators():
	var max_players: int = get_tree().get_nodes_in_group("players").size()
	for i in range(max_players - 1):
		var ind = load("res://scenes/ui/player_indicator.tscn").instantiate()
		add_child(ind, true)
		ind.visible = false
		indicators_pool.append(ind)
	other_players = _get_other_players()
	is_ready = true

func update_indicators() -> void:
	if not is_multiplayer_authority(): return
	
	for i in range(other_players.size()):
		var target_player: Player = other_players[i]
		var indicator = indicators_pool[i]
		if not target_player:
			indicator.visible = false
			continue
			
		var notifier = target_player.get_node_or_null("ScreenNotifier")
		var dir = target_player.global_position - owner.global_position
		
		indicator.global_position = owner.global_position
		
		if notifier and not notifier.is_on_screen():
			indicator.visible = true
			indicator.rotation = dir.angle()
		else:
			indicator.visible = false

func _get_other_players() -> Array[Player]:
	var all_players = get_tree().get_nodes_in_group("players")
	var result: Array[Player]
	for p in all_players:
		if not p is Player: continue
		if p == owner: continue
		result.push_back(p)
	return result
	
