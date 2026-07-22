extends Node2D

@export_category("Resource")
@export var ui: UI
@export var player_scene: PackedScene
@export var exp_orb_scene: PackedScene

@onready var player_container: Node2D = $PlayerContainer
@onready var enemy_container: Node2D = $EnemyContainer
@onready var exp_orb_container: Node2D = $ExpOrbContainer
@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var multiplayer_enemy_spawner: MultiplayerSpawner = $MultiplayerEnemySpawner
@onready var enemy_spawner: Node = $EnemySpawner
@onready var enemy_despawner: Node = $EnemySpawner/EnemyDespawner
@onready var upgrade_manager: UpgradeManager = $UpgradeManager

# Server variable
var players_spawn_ready_count: int = 0
var player_amount: int = 0
var player_died_amount: int = 0
var experience: int = 0
var experience_cap: int = 5
var level: int = 0

var time_elapsed: float = 0.0 # use for total time 
var is_timer_running: bool = true


func _ready() -> void:
	Lobby.server_disconnected.connect(_on_server_disconnected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	player_spawner.spawned.connect(_on_player_spawned)
	multiplayer_enemy_spawner.spawned.connect(_on_enemy_spawned)
	upgrade_manager.experience_changed.connect(ui.update_experience_display)
	upgrade_manager.level_changed.connect(ui.update_level_display)
	upgrade_manager.upgrade_started.connect(ui.show_pause_waiting)
	
	ui.update_experience_display(upgrade_manager.experience, upgrade_manager.experience_cap)
	ui.update_level_display(upgrade_manager.level)
	GameManager.change_pause_state(true)
	Lobby.player_loaded.rpc_id(1) # Tell server this client is ready

func _process(delta: float) -> void:		
	if is_timer_running:
		time_elapsed += delta
		ui.update_timer_display(time_elapsed)
	
	# press R
	if multiplayer.is_server() and Input.is_action_pressed("force_game_over"):
		game_over()
	
	# press E
	if Input.is_action_pressed("get_exp"):
		upgrade_manager.add_experience(1)

func _on_enemy_spawned(_enemy: Enemy) -> void:
	pass

## Give exp to main game
func _on_enemy_died(enemy: Enemy) -> void:
	var exp_orb: CharacterBody2D = exp_orb_scene.instantiate()
	exp_orb.global_position = enemy.global_position
	exp_orb.exp_amount = enemy.exp_amount
	exp_orb.collected.connect(upgrade_manager.add_experience)
	exp_orb.update_scale()
	exp_orb_container.call_deferred("add_child", exp_orb, true)

func _on_player_spawned(player: Player) -> void:
	player.player_stat.stat_upgrades = upgrade_manager.stat_upgrade_manager
	if not player.is_multiplayer_authority():
		return
	GameManager.local_player = player
	player.health_changed.connect(ui.update_health_display)
	player.max_health_changed.connect(ui.update_max_health_display)
	player.spectate_changed.connect(ui._update_spectate_display)
	ui.update_max_health_display(player.player_stat.hp)
	enemy_despawner.add_player.rpc(player.name.to_int())
	player.player_died.connect(enemy_despawner.remove_player_rpc)
	_report_player_ready.rpc_id(1)
		
func _on_player_died(id: int) -> void:
	if not multiplayer.is_server():
		return
	player_died_amount += 1
	if player_container.has_node(str(id)):
		var died_player: Player = player_container.get_node(str(id))
		died_player.remove_from_group("players")
	_check_game_over()
	
func _on_player_disconnected(id: int) -> void:
	if not multiplayer.is_server():
		return
	player_amount -= 1
	if player_container.has_node(str(id)):
		var disconnect_player: Player = player_container.get_node(str(id))
		if not disconnect_player.is_alive:
			player_died_amount -= 1
		else:
			disconnect_player.remove_from_group("players")
		# What if player shoot a projectile that didn't disappear yet?
		disconnect_player.queue_free()
	_check_game_over()

## All client will receive
func _on_server_disconnected() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

## Will be call when player disconnect or died
func _check_game_over() -> void:
	if player_died_amount == player_amount:
		game_over()

func game_over() -> void:
	if not multiplayer.is_server():
		await get_tree().create_timer(1.0).timeout
		return
	for enemy: Enemy in enemy_container.get_children():
		enemy.queue_free()
	for player: Player in player_container.get_children():
		player.queue_free()
	await get_tree().create_timer(1.0).timeout
	Lobby.return_to_lobby.rpc()
	GameManager.is_game_start = false

@rpc("any_peer", "call_local", "reliable")
func _report_player_ready() -> void:
	if not multiplayer.is_server():
		return
		
	players_spawn_ready_count += 1
	print("玩家 Ready 進度: %d/%d" % [players_spawn_ready_count, len(Lobby.players)])
	if players_spawn_ready_count >= len(Lobby.players):
		start_game.rpc()

## Called in lobby.gd
func spawn_players() -> void:
	for player_id in Lobby.players:
		player_amount += 1
		_add_player_node(player_id) 
		
func _add_player_node(id: int) -> void:
	var player: Player = player_scene.instantiate()
	player.global_position = Vector2.ZERO
	player.name = str(id)
	player.player_died.connect(_on_player_died)
	player_container.add_child(player)
	player.player_stat.stat_upgrades = upgrade_manager.stat_upgrade_manager
	
	if id == 1:
		_on_player_spawned(player)

@rpc("authority", "call_local", "reliable")
func start_game() -> void:
	print("Game Start!")
	GameManager.is_game_start = true
	GameManager.change_pause_state(false)
	
