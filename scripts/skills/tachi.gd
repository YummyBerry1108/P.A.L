extends Projectile

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var custom_anim_name: String = "attack"

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)
	hitbox = $RotCenter/Hitbox
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_area_entered)
	
	animation_player.play(custom_anim_name, -1, 2.0)
	animation_player.seek(0.0, true)
	await animation_player.animation_finished
	_before_lifespan_expired()
	queue_free()

func _physics_process(delta: float) -> void:
	global_position = owner.global_position
