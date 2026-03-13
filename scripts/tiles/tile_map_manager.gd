extends Node2D

@onready var snow: TileMapLayer = $Snow

var MAP_SIZE: Vector2 = Vector2(100, 100)

func _ready() -> void:
	var four_rotations = [
		0,
		TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
		TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
		TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V
	]
	
	for y in range(-MAP_SIZE.y/2, MAP_SIZE.y/2):
		for x in range(-MAP_SIZE.x/2, MAP_SIZE.x/2):
			snow.set_cell(Vector2(x, y), 8, Vector2(0, 0), four_rotations[randi_range(0, 0)])
