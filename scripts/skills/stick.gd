extends Projectile

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)
	hitbox = $RotCenter/Hitbox
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_aera_entered)
	
	animation_player.play("attack", -1, 2.0)
	
	await animation_player.animation_finished
	_before_lifespan_expired()

	queue_free()

func _physics_process(delta: float) -> void:
	global_position = owner.global_position
