extends Node

@export var map: TileMapLayer
@export var enemy_container: Node2D

const RADIUS = 8

var total_weight: int = 0
var available_coords: Dictionary = {}

func spawn_enemy(enemy_name: String = "rock") -> void:
	if not multiplayer.is_server():
		return
		
	available_coords.clear()
	total_weight = 0
	
	var player_coords: Array[Vector2i] = _get_player_coords()
	if player_coords.is_empty(): return
	_record_available_coord(player_coords)
	var res_coord: Vector2i = _choose_coord()
	
	var enemy_node: PackedScene = load("res://scenes/enemies/" + enemy_name + ".tscn")
	var new_enemy: Enemy = enemy_node.instantiate()
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
			var dy = RADIUS - abs(dx)
			var expect_coord: Vector2i = coord + Vector2i(dx, dy) 
			if expect_coord in available_coords:
				available_coords[expect_coord] += 1
			else:
				available_coords[expect_coord] = 1
			total_weight += 1
			
			if dy == 0: continue
			expect_coord = coord + Vector2i(dx, -dy)
			if expect_coord in available_coords:
				available_coords[expect_coord] += 1
			else:
				available_coords[expect_coord] = 1
			total_weight += 1

func _choose_coord() -> Vector2i:
	var rand_num: int = randi_range(0, total_weight)
	var curr_coord: Vector2i
	for coord: Vector2i in available_coords:
		curr_coord = coord
		if rand_num <= 0:
			return curr_coord
		rand_num -= available_coords[curr_coord]
	return curr_coord
