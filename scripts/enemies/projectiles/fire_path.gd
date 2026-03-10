extends Line2D

@onready var hitbox: Area2D = $Hitbox

@export var damage: int = 10
@export var duration: float = 2.0

var collision_shape: CollisionPolygon2D


func _ready():
	collision_shape = CollisionPolygon2D.new()
	hitbox.add_child(collision_shape)
	
	get_tree().create_timer(duration).timeout.connect(func(): queue_free())

func update_path(start_pos: Vector2, current_pos: Vector2):
	clear_points()
	add_point(to_local(start_pos))
	add_point(to_local(current_pos))
	
	_update_collision(to_local(start_pos), to_local(current_pos))

func _update_collision(p1: Vector2, p2: Vector2):
	var dir = (p2 - p1).normalized()
	var normal = Vector2(-dir.y, dir.x) * (width / 2.0)
	
	# Create a rectangle polygon around the line segment
	var poly = PackedVector2Array([
		p1 + normal,
		p2 + normal,
		p2 - normal,
		p1 - normal
	])
	collision_shape.polygon = poly
