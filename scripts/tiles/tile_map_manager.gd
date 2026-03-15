extends Node2D

@onready var snow: TileMapLayer = $Snow
@onready var lava: TileMapLayer = $Lava

var MAP_SIZE: Vector2 = Vector2(100, 100)

func _ready() -> void:
	var H_flip = [
		0,
		TileSetAtlasSource.TRANSFORM_FLIP_H,
	]
	var V_flip = [
		0,
		TileSetAtlasSource.TRANSFORM_FLIP_V,
	]
	for y in range(-MAP_SIZE.y/2, MAP_SIZE.y/2):
		for x in range(-MAP_SIZE.x/2, MAP_SIZE.x/2):
			lava.set_cell(Vector2(x, y), 3, Vector2(0, 0), V_flip[((y%2)+2)%2] | H_flip[((x%2)+2)%2])
