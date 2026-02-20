class_name AnimationComponent
extends Node

@export var actor: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D

func _process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	animated_sprite_2d.flip_h = animated_sprite_2d.flip_h if actor.velocity.x == 0 else actor.velocity.x < 0 
	
	if actor.velocity.length() == 0:
		animated_sprite_2d.frame = 0
	else:
		animated_sprite_2d.play()
		
