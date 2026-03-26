extends Node

@export var map: TileMapLayer
@export var enemy_container: Node2D
@export var difficulty_curve: Curve
@export var spawn_amount_curve: Curve
@export var max_game_time: float = 1800.0
@export var base_spawn_interval: float = 5.0
@export var min_spawn_interval: float = 2.0
@export var base_enemy_count: int = 1

@onready var spawn_timer: Timer = $SpawnTimer

const RADIUS = 40

var current_time: float = 0.0
var player_count: int = 0
var total_weight: int = 0
var available_coords: Dictionary = {}

var enemy_names: Array[String] = ["snail", "rabbit", "rock"]
var name_to_enemy: Dictionary[String, PackedScene] = {
	"rock": preload("res://scenes/enemies/rock.tscn"),
	"rabbit": preload("res://scenes/enemies/rabbit.tscn"),
	"snail": preload("res://scenes/enemies/snail.tscn"),
}
var name_to_difficulty: Dictionary[String, float] = {
	"rock": 1.8,
	"rabbit": 1.5,
	"snail": 1.0,
}

func _ready() -> void:
	if not multiplayer.is_server():
		return
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start(base_spawn_interval)

func _process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	if current_time < max_game_time:
		current_time += delta
		update_spawner_difficulty()
	player_count = get_tree().get_node_count_in_group("players")
	#print(_get_difficulty())

func update_spawner_difficulty() -> void:
	var new_interval: float = lerp(base_spawn_interval, min_spawn_interval, _get_difficulty() / 10)
	
	if abs(spawn_timer.wait_time - new_interval) > 0.05:
		var time_left = spawn_timer.time_left
		spawn_timer.wait_time = max(new_interval, 0.01)
		if time_left > spawn_timer.wait_time:
			spawn_timer.start(spawn_timer.wait_time)

func _on_spawn_timer_timeout() -> void:
	var spawn_count: int = base_enemy_count + int(_get_spawn_amount() + player_count * 0.5)
	
	for i in range(spawn_count):
		spawn_enemy()
	
	print("生成數: ", spawn_count)
	print("生成時間: ", spawn_timer.wait_time)

## do not spawn if no player alive in game
func spawn_enemy() -> void:
	if not multiplayer.is_server():
		return
	
	var difficulty: float = _get_difficulty()
	var available_name: Array[String]
	
	for enemy_name in enemy_names:
		if name_to_difficulty[enemy_name] <= difficulty:
			available_name.append(enemy_name)
	
	var selected_enemy: String = available_name.pick_random()
	
	available_coords.clear()
	total_weight = 0
	
	var player_coords: Array[Vector2i] = _get_player_coords()
	if player_coords.is_empty(): return
	_record_available_coord(player_coords)
	var res_coord: Vector2i = _choose_coord()
	
	var enemy_node: PackedScene = name_to_enemy[selected_enemy]
	var new_enemy: Enemy = enemy_node.instantiate()
	new_enemy.multiplier = max(1, difficulty / 2 + player_count * 0.5)
	new_enemy.global_position = map.map_to_local(res_coord)
	new_enemy._on_enemy_died.connect(owner._on_enemy_died)
	enemy_container.add_child(new_enemy, true)


## get tilemap coords
func _get_player_coords() -> Array[Vector2i]:
	var coords: Array[Vector2i] = []
	var players = get_tree().get_nodes_in_group("players")
	for player: Player in players:
		var player_pos : Vector2 = player.global_position
		var map_pos: Vector2i = map.local_to_map(player_pos)
		coords.append(map_pos)
	return coords

func _record_available_coord(player_coords: Array[Vector2i]) -> void:
	for coord: Vector2i in player_coords:
		for dx in range(-RADIUS, RADIUS+1):
			var base_dy: int = RADIUS - abs(dx)
			var dy_values: Array[int]
			if base_dy == 0:
				dy_values = [base_dy] 
			else:
				dy_values = [base_dy, -base_dy]
			
			for dy in dy_values:
				var expect_coord: Vector2i = coord + Vector2i(dx, dy)
				
				if _check_coord_close_player(expect_coord, player_coords):
					continue
				
				if expect_coord in available_coords:
					available_coords[expect_coord] += 1
				else:
					available_coords[expect_coord] = 1
				total_weight += 1
				
## return true if coord too close a player
func _check_coord_close_player(expect_coord: Vector2i, player_coords) -> bool:
	for other_coord in player_coords:
		var diff: Vector2i = expect_coord - other_coord
		if abs(diff.x) + abs(diff.y) < RADIUS:
			return true
	return false

func _choose_coord() -> Vector2i:
	var rand_num: int = randi_range(0, total_weight)
	var curr_coord: Vector2i
	for coord: Vector2i in available_coords:
		curr_coord = coord
		if rand_num <= 0:
			return curr_coord
		rand_num -= available_coords[curr_coord]
	return curr_coord

func _get_difficulty() -> float:
	var progress: float = clamp(current_time / max_game_time, 0.0, 1.0)
	var difficulty_multiplier: float = difficulty_curve.sample(progress)
	return difficulty_multiplier

func _get_spawn_amount() -> float:
	var progress: float = clamp(current_time / max_game_time, 0.0, 1.0)
	var spawn_amount: float = spawn_amount_curve.sample(progress)
	return spawn_amount
