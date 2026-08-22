extends Area2D

## 巫王帽帽的單一圓形打擊區。由 witch_hat.gd 生成。
## 傷害判定不在這裡：敵人的 DamageComponent 會用 area.owner 反查回 Projectile 本體，
## 這個腳本只負責表現（彈出、符文旋轉、淡出、落地粒子）。

@export var pop_time: float = 0.10
@export var hold_time: float = 0.16
@export var fade_time: float = 0.18
@export var rune_spin: float = 1.8

@onready var ring: Sprite2D = $Sprite2D
@onready var rune: Sprite2D = $Rune
@onready var impact: CPUParticles2D = $Impact

func _ready() -> void:
	var target: Vector2 = ring.scale
	ring.scale = target * 0.3
	modulate.a = 0.0
	if impact:
		impact.restart()

	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(ring, "scale", target, pop_time) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "modulate:a", 1.0, pop_time * 0.7)
	tw.chain()
	tw.tween_interval(hold_time)
	tw.chain()
	tw.tween_property(self, "modulate:a", 0.0, fade_time)

func _process(delta: float) -> void:
	if rune:
		rune.rotation += rune_spin * delta
