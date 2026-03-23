extends Node2D

@onready var snow: TileMapLayer = $Snow
@onready var lava: TileMapLayer = $Lava


var MAP_SIZE: Vector2 = Vector2(20, 20)

const H_flip = [0, TileSetAtlasSource.TRANSFORM_FLIP_H]
const V_flip = [0, TileSetAtlasSource.TRANSFORM_FLIP_V]
var tile_size

func get_pos_and_flip(y, x) -> Array:
	var x_big:int = floor(x / tile_size.x)
	var y_big:int = floor(y / tile_size.y)
	lava.set_cell(Vector2(y, x), 1, Vector2(pos_mod(y, tile_size.y), pos_mod(x, tile_size.x)), V_flip[pos_mod(y_big, 2)] | H_flip[pos_mod(x_big, 2)])
	var vf = V_flip[pos_mod(y_big, 2)]
	var hf = H_flip[pos_mod(x_big, 2)]
	#var atlas_y = (tile_size.y - pos_mod(y, tile_size.y))%tile_size.y if vf else pos_mod(y, tile_size.y);
	#var atlas_x = (tile_size.x - pos_mod(x, tile_size.x))%tile_size.x if hf else pos_mod(x, tile_size.x);
	var atlas_y = pos_mod(y, tile_size.y);
	var atlas_x = pos_mod(x, tile_size.x);

	#print(Vector2(atlas_y, atlas_x))
	
	return [Vector2(atlas_y, atlas_x), vf | hf]
	
func pos_mod(x, modulo) -> int:
	return (x % modulo + modulo) % modulo

func _ready() -> void:
	tile_size = Vector2i(1000/snow.tile_set.tile_size.x, 1000/snow.tile_set.tile_size.y) 
	MAP_SIZE = Vector2(MAP_SIZE.x * tile_size.x, MAP_SIZE.y * tile_size.y)
	print(MAP_SIZE)
	for y:int in range(-MAP_SIZE.y/2, MAP_SIZE.y/2, 1):
		for x:int in range(-MAP_SIZE.x/2, MAP_SIZE.x/2, 1):
			var atlas_settings = get_pos_and_flip(y, x)
			print(atlas_settings[1])
			lava.set_cell(Vector2(y, x), 1, atlas_settings[0], atlas_settings[1])

func lava_add_cell(x, y, id) -> void:
	lava.set_cell(Vector2(x, y), id, Vector2(0, 0), V_flip[((y%2)+2)%2] | H_flip[((x%2)+2)%2])

func lava_erase_cell(x, y) -> void:
	lava.erase_cell(Vector2(x, y))
