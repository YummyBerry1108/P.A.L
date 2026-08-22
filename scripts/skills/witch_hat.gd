extends Projectile

"""
巫王帽帽：
在螢幕範圍內隨機落下數個圓形打擊區域，每個圓造成一次打擊傷害。
圓形數量 = 1 + floor(X / stacks_per_extra_circle)，X 來自 ArcaneStackComponent。

所有落點都由 spawn_seed 推導，因此 server 與每個 client 會算出完全相同的座標；
真正造成傷害的只有 server 那一份（DamageComponent 有 is_server 把關）。
"""

@export var circle_scene: PackedScene
## 相機 zoom 0.35 + 1280x720 視窗下，大約就是一個螢幕的世界座標範圍
@export var spawn_area: Vector2 = Vector2(3600, 2000)
@export var max_circles: int = 12
@export var circle_lifespan: float = 0.5

func _ready() -> void:
	# 本體只是容器：不旋轉、不縮放、不移動。
	# skill_data.scale 只套到每個圓，這樣「圓形範圍增大」不會連帶把落點散開。
	rotation = 0.0
	var circle_scale: Vector2 = scale
	scale = Vector2.ONE
	set_physics_process(false)

	var rng := RandomNumberGenerator.new()
	rng.seed = spawn_seed

	var circle_count: int = mini(1 + _get_extra_circle_count(), max_circles)
	for i in circle_count:
		_spawn_circle(rng, circle_scale)

	await get_tree().create_timer(circle_lifespan).timeout
	_before_lifespan_expired()
	queue_free()

func _spawn_circle(rng: RandomNumberGenerator, circle_scale: Vector2) -> void:
	if circle_scene == null:
		push_warning("巫王帽帽沒有指定 circle_scene，這次不會產生任何圓。")
		return

	var circle: Node2D = circle_scene.instantiate()
	circle.position = Vector2(
		rng.randf_range(-spawn_area.x * 0.5, spawn_area.x * 0.5),
		rng.randf_range(-spawn_area.y * 0.5, spawn_area.y * 0.5)
	)
	circle.scale = circle_scale
	add_child(circle)
	# DamageComponent 是用 area.owner 反查 Projectile 的，owner 必須指回本體
	circle.owner = self


func _get_extra_circle_count() -> int:
	if not is_instance_valid(actor):
		return 0
	var component := actor.get_node_or_null("ArcaneStackComponent") as ArcaneStackComponent
	if component == null:
		return 0
	return component.get_extra_circle_count()
