class_name Enemy extends CharacterBody2D

@export var texture: Texture2D
@export_category("Basic")
@export var hp: float = 50
@export var damage: float = 10.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var hurt_box: Area2D = $HurtBox
@onready var effect_component: EffectComponent = $EffectComponent
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer
@onready var damage_component: DamageComponent = $DamageComponent
@onready var knockback_component: KnockbackComponent = $KnockbackComponent

#@onready var dev_info: Label = $DevInfo

var speed: float = 100
var speed_multiplier: float = 1.0
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func _ready() -> void:
	if texture:
		sprite.texture = texture
		
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	velocity = direction * speed * speed_multiplier

	move_and_slide()

func update_speed() -> void:
	speed_multiplier = effect_component.get_speed_multiplier()

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
	queue_free()
