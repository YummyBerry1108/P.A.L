class_name FireTrail extends Line2D

@onready var hitbox: Area2D = $Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var damage: int = 10
@export var duration: float = 2.0

var current_img_index: int = 0
var collision_shape: CollisionPolygon2D

var flip: bool = true

func _ready():
	collision_shape = CollisionPolygon2D.new()
	hitbox.add_child(collision_shape, true)
	
	get_tree().create_timer(duration).timeout.connect(func(): queue_free())

func update_path(start_pos: Vector2, current_pos: Vector2):
	clear_points()
	add_point(to_local(start_pos))
	add_point(to_local(current_pos))
	
	
	if !multiplayer.is_server(): return
	_update_collision(to_local(start_pos), to_local(current_pos))
	
func _update_collision(p1: Vector2, p2: Vector2):
	var dir = (p2 - p1).normalized()
	var normal = Vector2(-dir.y, dir.x) * (width / 3.0)
	
	var poly = PackedVector2Array([
		p1 + normal,
		p2 + normal,
		p2 - normal,
		p1 - normal
	])
	collision_shape.polygon = poly
