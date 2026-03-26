class_name Player extends CharacterBody2D

signal health_changed(health: float)
signal max_health_changed(health: float)
signal player_died(id: int)
signal spectate_changed(name: String) # used in spectate.gd

@onready var hurt_box: Area2D = $HurtBox
@onready var invincibility_timer: Timer = $HurtBox/InvincibilityTimer
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var projectiles: Node = $Projectiles
@onready var display_name: Label = $DisplayName
@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_stat: PlayerStatData = $PlayerStat
@onready var effect_component: EffectComponent = $EffectComponent

@export var is_invincible: bool = false
@export var is_alive: bool = true
@export var username: String

var is_spectating = false
var spectate_target: Player = null 

var skills: Dictionary = {}

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	add_to_group("players")
	if "name" in Lobby.players[name.to_int()]:
		username = Lobby.players[name.to_int()]["name"]
	else:
		username = "Guest " + str(name)
	display_name.text = username
	
	health_changed.connect(health_bar._set_health)
	max_health_changed.connect(health_bar.init_health)
	health_bar.init_health(player_stat.hp)
	
	if is_multiplayer_authority():
		UpgradeEventbus.stat_upgrade.connect(player_stat._on_stat_upgrade_received)
		health_bar.hide()
		display_name.hide()
		$Camera2D.make_current()
		
	if multiplayer.is_server():
		_apply_healing_effect()

func _apply_healing_effect() -> void:
	var new_inf_heal_effect = INFHealEffect.new()
	new_inf_heal_effect.duration = 1.0
	effect_component.add_effect(new_inf_heal_effect)

func _process(delta: float) -> void:
	if is_alive:
		pull_skills()
		fetch_behavior("Attack", { "player": self, "skills": skills })
	if is_spectating:
		fetch_behavior("Spectate", { "player": self, "is_spectating": is_spectating,"spectate_target": spectate_target, "camera": $Camera2D})

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	fetch_behavior("Movement", { "player": self, "SPEED": player_stat.SPEED * effect_component.get_speed_multiplier(player_stat.speed_mutiplier), "delta": delta })
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if not multiplayer.is_server():
		return
	if is_invincible:
		return 
	
	var enemy_root: Node2D = area.owner
	var enemy_damage: float = 0.0
	if is_instance_of(enemy_root, Enemy):
		enemy_damage = enemy_root.damage
	elif "damage" in enemy_root:
		enemy_damage = enemy_root.damage
	
	take_damage.rpc(enemy_damage)
	
func _on_timer_timeout() -> void:
	is_invincible = false
	var overlapping_areas = hurt_box.get_overlapping_areas()
	if overlapping_areas.is_empty():
		return
	else:
		_on_hurt_box_area_entered(overlapping_areas[0])

func start_spectating():
	is_spectating = true
	$Behaviors/Spectate.switch_to_next_player()

@rpc("any_peer", "call_local")
func take_damage(damage: float) -> void:
	if not is_alive:
		return
	player_stat.hp -= damage
	if player_stat.hp <= 0:
		player_stat.hp = 0
		die()
	health_changed.emit(player_stat.hp)
	is_invincible = true
	invincibility_timer.start()

@rpc("any_peer", "call_local")
func heal(amount: float) -> void:
	if not is_alive:
		return
	player_stat.hp += amount
	if player_stat.hp > player_stat.max_hp:
		player_stat.hp = player_stat.max_hp
	
	health_changed.emit(player_stat.hp)

func die() -> void:
	is_alive = false
	player_died.emit(name.to_int())
	set_physics_process(false)
	sprite_2d.frame = 0
	if is_multiplayer_authority():
		$Camera2D.enabled = false
		start_spectating()

func fetch_behavior(behavior_name: String, args: Dictionary) -> void:
	get_node_or_null("Behaviors/" + behavior_name).run(args)

func pull_skills() -> void:
	for child: SkillData in get_node("Skills").get_children():
		skills[child.skill_name] = child
