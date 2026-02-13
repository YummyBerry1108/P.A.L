extends Projectile
	
func _on_hurt_box_aera_entered(_area: Area2D) -> void:
	queue_free()
