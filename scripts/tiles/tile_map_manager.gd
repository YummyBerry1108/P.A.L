extends Node2D

@onready var snow: TileMapLayer = $Snow
@onready var lava: TileMapLayer = $Lava


var MAP_SIZE: Vector2 = Vector2(20, 20)

const H_flip = [0, TileSetAtlasSource.TRANSFORM_FLIP_H]
const V_flip = [0, TileSetAtlasSource.TRANSFORM_FLIP_V]
var tile_size

func pos_mod(x, modulo) -> int:
	x = int(x)
	modulo = int(modulo)
	return (x % modulo + modulo) % modulo

func get_pos_and_flip(x, y) -> Array:
	var x_big:int = floor(x / tile_size.x)
	var y_big:int = floor(y / tile_size.y)
	var vf = V_flip[pos_mod(y_big, 2)]
	var hf = H_flip[pos_mod(x_big, 2)]
	var atlas_y = pos_mod((tile_size.y - pos_mod(y, tile_size.y) - 1), tile_size.y) if vf != 0 else pos_mod(y, tile_size.y);
	var atlas_x = pos_mod((tile_size.x - pos_mod(x, tile_size.x) - 1), tile_size.x) if hf != 0 else pos_mod(x, tile_size.x);

	return [Vector2(atlas_x, atlas_y), vf | hf]

func _ready() -> void:
	@warning_ignore("integer_division")
	tile_size = Vector2(1000/snow.tile_set.tile_size.x, 1000/snow.tile_set.tile_size.y) 
	MAP_SIZE = Vector2(MAP_SIZE.x * tile_size.x, MAP_SIZE.y * tile_size.y)
	#print(MAP_SIZE)
	for y:int in range(-MAP_SIZE.y/2, MAP_SIZE.y/2, 1):
		for x:int in range(-MAP_SIZE.x/2, MAP_SIZE.x/2, 1):
			snow_add_cell(x, y, 1)

func snow_add_cell(x, y, id) -> void:
	var atlas_settings = get_pos_and_flip(x, y)
	snow.set_cell(Vector2(x, y), id, atlas_settings[0], atlas_settings[1])

func lava_add_cell(x, y, id) -> void:
	var atlas_settings = get_pos_and_flip(x, y)
	lava.set_cell(Vector2(x, y), id, atlas_settings[0], atlas_settings[1])

func lava_erase_cell(x, y) -> void:
	lava.erase_cell(Vector2(x, y))
