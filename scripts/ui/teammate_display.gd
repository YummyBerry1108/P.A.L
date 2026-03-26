extends TextureRect
@export var player_info_container: VBoxContainer

var player_nodes: Array[Player]
var player_to_label: Dictionary[Player, Label]
var player_ready: bool = false

func _ready() -> void:
	Lobby.all_player_ready.connect(_on_all_player_ready)
	for label in player_info_container.get_children():
		label.text = ""

func _process(delta: float) -> void:
	if not player_ready: return
	var labels = player_info_container.get_children()
	for i in range(min(player_info_container.get_children().size(), player_nodes.size())):
		var player = player_nodes.get(i)
		var label: Label = labels[i]
		
		if not player: 
			label.text = ""
			continue
		
		label.text = \
		player.username + \
		": " + \
		str(int(player.player_stat.hp)) + \
		" / " + \
		str(int(player.player_stat.max_hp))

func _on_all_player_ready() -> void:
	player_ready = true
	var players = get_tree().get_nodes_in_group("players")
	var labels = player_info_container.get_children()
	
	for player in players:
		if player.name == str(multiplayer.get_unique_id()): continue
		player_nodes.append(player)
	
	if not player_nodes:
		visible = false
		return
	
	for idx in range(player_nodes.size()):
		player_to_label[player_nodes[idx]] = labels[idx]
	
