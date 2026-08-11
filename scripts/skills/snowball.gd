extends Projectile
	
func _on_hurt_box_area_entered(_area: Area2D) -> void:
	queue_free()
