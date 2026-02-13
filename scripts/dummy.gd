extends CharacterBody2D
@onready var damage_number_position: Node2D = $DamageNumberPosition # Only for damage position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hurt_box_area_entered(area: Area2D) -> void:
	DamageNumber.display_number(10, damage_number_position.global_position, false)
	$HitFlashAnimationPlayer.play("hit_flash")
