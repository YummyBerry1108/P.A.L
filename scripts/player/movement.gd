extends Node

func run(args) -> void:
	WASD_movement(args["player"], args["SPEED"], args["delta"])

func WASD_movement(player, SPEED, delta):
	var dir = Vector2(0, 0)
	
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	
	player.velocity = dir * SPEED * delta * 60
	
