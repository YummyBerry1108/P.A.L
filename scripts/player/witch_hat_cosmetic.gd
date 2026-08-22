class_name WitchHatCosmetic extends Node2D

## 玩家頭上戴的巫王帽帽。純外觀，不參與任何傷害判定。
## 每個 peer 都會自己播：skill_fired 由 projectiles.add_projectile 觸發，
## 而那本來就在每個 peer 上各跑一次，所以不需要額外的 rpc。

@export var skill_name: String = "witch_hat"
## 相對玩家原點的配戴位置（豬頭在右側；轉向時 x 會自動鏡射）
@export var worn_offset: Vector2 = Vector2(56, -128)
@export var bob_amplitude: float = 3.0
@export var bob_speed: float = 2.4
## 星塵密度拉滿所需的堆疊數
@export var sparkle_full_at: float = 400.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var sparkle: CPUParticles2D = $Sparkle
@onready var burst: CPUParticles2D = $Burst

var _player: Player
var _stacks: ArcaneStackComponent
var _cast_tween: Tween
var _time := 0.0
var _facing := 1.0
var _base_scale := Vector2.ONE

func _ready() -> void:
	_player = owner as Player
	if _player == null:
		return
	_player.skill_fired.connect(_on_skill_fired)
	_stacks = _player.get_node_or_null("ArcaneStackComponent")
	_base_scale = sprite.scale  # 記住場景設定的尺寸，動畫結束要回到這個值
	visible = false
	call_deferred("_refresh_visibility")

## 帽帽被 disable 時整個外觀都不該出現
func _refresh_visibility() -> void:
	if _player == null:
		return
	visible = _player.skills.has(skill_name) and not _player.skills[skill_name].disable
	if sparkle:
		sparkle.emitting = visible

func _process(delta: float) -> void:
	if _player == null:
		return
	if not visible:
		_refresh_visibility()
		return

	_time += delta

	# 跟著玩家的朝向鏡射
	var flip: bool = _player.sprite_2d.flip_h
	_facing = -1.0 if flip else 1.0
	sprite.flip_h = flip
	position.x = worn_offset.x * _facing
	position.y = worn_offset.y + sin(_time * bob_speed) * bob_amplitude

	# 堆疊越高，帽子上的星塵越旺（改 alpha 與速度，不動 amount 以免粒子系統重置）
	if _stacks != null and sparkle != null:
		var t: float = clampf(float(_stacks.get_stack_count()) / sparkle_full_at, 0.0, 1.0)
		sparkle.self_modulate.a = 0.35 + 0.65 * t
		sparkle.speed_scale = 1.0 + t * 0.9

func _on_skill_fired(fired: String) -> void:
	if fired == skill_name and visible:
		_play_cast()

## 帽尖往後仰蓄力，再彈回來
func _play_cast() -> void:
	if burst:
		burst.restart()
	if _cast_tween != null and _cast_tween.is_valid():
		_cast_tween.kill()
	sprite.rotation = 0.0
	sprite.scale = _base_scale

	_cast_tween = create_tween()
	_cast_tween.set_parallel(true)
	_cast_tween.tween_property(sprite, "rotation", -0.55 * _facing, 0.07) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_cast_tween.tween_property(sprite, "scale", _base_scale * Vector2(1.16, 0.86), 0.07) \
		.set_trans(Tween.TRANS_QUAD)
	_cast_tween.chain()
	_cast_tween.tween_property(sprite, "rotation", 0.0, 0.34) \
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_cast_tween.tween_property(sprite, "scale", _base_scale, 0.34) \
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
