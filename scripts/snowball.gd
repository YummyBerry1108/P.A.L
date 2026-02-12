extends Projectile

func _ready() -> void:
	super._ready()
	

func _on_hurt_box_aera_entered(area: Area2D) -> void:
	queue_free()
