class_name Projectile extends CharacterBody2D

@onready var hitbox: Area2D = get_node_or_null("Hitbox")

@export var initial_speed: float = 240.0
@export var target_speed: float = 240.0
@export var acceleration: float = 0.0
@export var lifespan: float = 1.0

var skill_data: SkillData
var actor: Node
var damage: float = 0.0

var speed: float = 0.0
var direction: Vector2 = Vector2.RIGHT
var hit_count: int = 0

func _ready() -> void:
	speed = initial_speed
	direction = Vector2.RIGHT.rotated(global_rotation)
	
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_area_entered)

	await get_tree().create_timer(lifespan).timeout
	_before_lifespan_expired()
	queue_free()

func _physics_process(delta: float) -> void:
	speed = lerp(speed, target_speed, acceleration * delta)
	velocity = direction * speed

	var collision: bool = move_and_slide()
	if collision:
		queue_free()
	
func _before_lifespan_expired() -> void:
	if not multiplayer.is_server():
		return
	if skill_data:
		var expire_ctx = SkillContext.new(skill_data, actor)
		expire_ctx.projectile = self
		expire_ctx.hit_count = hit_count
		skill_data.trigger_projectile_expired(expire_ctx)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	pass
