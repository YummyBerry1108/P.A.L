class_name AnimationComponent
extends Node

@export var actor: Enemy
@export var animated_sprite_2d: AnimatedSprite2D

func _process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	
	# only enemy class have this
	var vector_to_player = actor.global_position.direction_to(actor.get_nearest_player())
	animated_sprite_2d.flip_h = animated_sprite_2d.flip_h if vector_to_player.x == 0 else vector_to_player.x < 0 
	
	if actor.velocity.length() == 0:
		animated_sprite_2d.frame = 0
	else:
		animated_sprite_2d.play()
		
