extends Projectile

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var hit_count: int = 0


func _ready() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)
	hitbox = $RotCenter/Hitbox
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_area_entered)
	
	animation_player.play("attack", -1, 2.0)
	await animation_player.animation_finished
	#animation_player.play("attack_counterclockwise", -1, 2.0)
	#await animation_player.animation_finished
	_before_lifespan_expired()
	queue_free()

func _physics_process(delta: float) -> void:
	global_position = owner.global_position

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area == null or area.owner == null or actor == null: return
	hit_count += 1
	for effect: StatusEffectRes in status_effects:
		if effect is SpeedUpEffect:
			actor.effect_component.add_effect(effect)

func _before_lifespan_expired() -> void:
	if hit_count != 1:
		return
	actor.get_node_or_null("Behaviors/Attack").cooldowns.erase("tachi")
