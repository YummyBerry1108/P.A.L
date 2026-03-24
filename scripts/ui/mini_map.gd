extends SubViewport

@onready var mini_map_camera: Camera2D = $MiniMapCamera

func _ready() -> void:
	world_2d = get_tree().root.world_2d

func _process(delta: float) -> void:
	if GameManager.local_player:
		mini_map_camera.position = GameManager.local_player.global_position
