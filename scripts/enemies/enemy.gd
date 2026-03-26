class_name Enemy extends CharacterBody2D

signal _on_enemy_died(enemy: Enemy)

enum VariantType {normal, elite}

var exp_orb_scene: Resource = preload("res://scenes/etc/exp_orb.tscn")
#@onready var dev_info: Label = $DevInfo

@export var texture: Texture2D
@export_category("Basic")
@export var hp: float = 50
@export var damage: float = 10.0
@export var multiplier: float = 1.0
@export var despawn_time: float = 15.0

@onready var animated_sprite_2d: AnimatedSprite2D = get_node("AnimatedSprite2D")
#@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var hurt_box: Area2D = get_node("HurtBox")
@onready var effect_component: EffectComponent = get_node("EffectComponent")
@onready var hit_flash_animation_player: AnimationPlayer = get_node("HitFlashAnimationPlayer")
@onready var damage_component: DamageComponent = get_node("DamageComponent")
@onready var knockback_component: KnockbackComponent = get_node("KnockbackComponent")
#@onready var dev_info: Label = $DevInfo

@export var variant_type: VariantType = VariantType.normal

var visible_on_screen_notifier_2D: VisibleOnScreenNotifier2D
var despawn_timer: Timer

var speed: float = 100
var speed_multiplier: float = 1.0
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var exp_amount: int = 1
var color: String = "red"


func _ready() -> void:
	hp *= multiplier
	
	_set_up_variant_stat()
	setup_despawn_timer()

func _set_up_variant_stat() -> void:
	pass

func setup_despawn_timer() -> void:
	visible_on_screen_notifier_2D = VisibleOnScreenNotifier2D.new()
	despawn_timer = Timer.new()
	despawn_timer.autostart = false
	despawn_timer.wait_time = despawn_time
	
	
	despawn_timer.timeout.connect(_despawn)
	
	visible_on_screen_notifier_2D.screen_exited.connect(_on_screen_exited)
	visible_on_screen_notifier_2D.screen_entered.connect(_on_screen_entered)
	
	add_child(visible_on_screen_notifier_2D)
	add_child(despawn_timer)

func _on_screen_entered() -> void:
	despawn_timer.stop()

func _on_screen_exited() -> void:
	despawn_timer.start()

func _despawn() -> void:
	queue_free()
	#die()

func update_speed() -> void:
	speed_multiplier = effect_component.get_speed_multiplier()
		
## find player by group, return the nearest player's position
func get_nearest_player() -> Vector2:
	var min_distance: float = INF
	var res: Vector2 = Vector2.ZERO
	var players = get_tree().get_nodes_in_group("players")
	
	for player in players:
		var player_pos : Vector2 = player.global_position
		var distance : float = global_position.distance_to(player_pos)
		if distance < min_distance:
			min_distance = distance
			res = player_pos
	
	return res

func die() -> void:
	_on_enemy_died.emit(self)
	queue_free()
