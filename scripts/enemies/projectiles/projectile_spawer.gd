extends Node2D

@export var projectile_scene: PackedScene
var projectile_container: Node2D

func _ready() -> void:
	for container in get_tree().get_nodes_in_group("containers"):
		if container.name == "ProjectileContainer":
			projectile_container = container

@rpc("any_peer", "call_local")
func spawn() -> Node2D:
	var projectile = projectile_scene.instantiate()
	return projectile
	
