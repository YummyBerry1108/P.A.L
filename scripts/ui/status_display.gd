extends TextureRect

@export var button_container: VBoxContainer
@export var status_label: Label

var player_data: PlayerStatData
var player_ready: bool = false
var is_close: bool = false

func _ready() -> void:
	Lobby.all_player_ready.connect(_on_all_player_ready)

func _process(delta: float) -> void:
	if not ready or not player_data: return
	status_label.text = "
	Max HP: %d
	Damage: %d
	Speed Multiplier: %.1f
	" % [ int(player_data.max_hp), player_data.damage, player_data.speed_mutiplier ]

func _on_all_player_ready() -> void:
	var players = get_tree().get_nodes_in_group("players")
	
	player_ready = true
	
	for player: Player in players:
		if player.name == str(multiplayer.get_unique_id()): 
			player_data = player.player_stat
			
func _on_toggle_button_pressed() -> void:
	is_close = not is_close
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	
	if is_close:
		tween.tween_property(self, "position", Vector2(240, 0), 0.5).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(self, "position", Vector2(0, 0), 0.5).set_ease(Tween.EASE_OUT)
