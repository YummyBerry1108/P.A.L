extends Node

func run(args: Dictionary) -> void:
	WASD_movement(args["player"], args["SPEED"], args["delta"])

func WASD_movement(player: Player, SPEED: float, delta: float) -> void:
	var dir = Vector2(0, 0)
	var animation_sprite: AnimatedSprite2D = player.sprite_2d
	
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	
	animation_sprite.flip_h = animation_sprite.flip_h if dir.x == 0 else dir.x < 0 
	
	if(dir.length() == 0):
		animation_sprite.frame = 0
	else:
		animation_sprite.play()
	
	player.velocity = dir * SPEED
	
