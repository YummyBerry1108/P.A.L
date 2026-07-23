extends Projectile

"Note: the hitbox of weapon close the Monitorable property"
"""
環繞之浪：
1. 攻擊：在周圍形成圓形的緩速打擊傷害(傷害比較低)
2. 升級路線：圓形範圍增加、緩速量增加、傷害提升並且吸血(傷害增加量也比較低)
"""

@onready var cooldown_timer: Timer = $CooldownTimer

var target_player: Player = null
var skill_data: SkillData = null
var enemys: Dictionary = {} # record enemy in the hitbox of this weapon

func _ready() -> void:
	rotation = 0
	if hitbox:
		if not hitbox.area_entered.is_connected(_on_hitbox_area_entered):
			hitbox.area_entered.connect(_on_hitbox_area_entered)
		if not hitbox.area_exited.is_connected(_on_hitbox_area_exited):
			hitbox.area_exited.connect(_on_hitbox_area_exited)

	_setup_target_player()

func _physics_process(delta: float) -> void:

	if is_instance_valid(target_player):
		global_position = target_player.global_position
	else:
		queue_free()

func _setup_target_player() -> void:
	var players = get_tree().get_nodes_in_group("players")
	for player: Player in players:
		if player.name == str(shooter_id):
			target_player = player
			break
			
	if not target_player:
		push_warning("環繞之浪找不到對應的 Shooter ID: " + str(shooter_id))
		return
		
	if target_player.skills.has("wave"):
		skill_data = target_player.skills["wave"]
		apply_skill_data()
		if skill_data.has_signal("skill_updated"):
			skill_data.skill_updated.connect(apply_skill_data)

func apply_skill_data() -> void:
	if not skill_data:
		return
		
	status_effects = skill_data.status_effects
	damage = skill_data.projectile_damage
	if skill_data.firerate > 0:
		cooldown_timer.wait_time = skill_data.cooldown
	if "scale" in skill_data:
		scale = Vector2.ONE * skill_data.scale

func _on_cooldown_timer_timeout() -> void:
	if not multiplayer.is_server():
		return

	var current_enemies = enemys.keys().duplicate()
	for enemy in current_enemies:
		if not is_instance_valid(enemy):
			enemys.erase(enemy)
			continue
			
		var damage_component: DamageComponent = enemy.get("damage_component")
		if damage_component == null: 
			print("Damage Component disappear!")
			return
		damage_component.process_projectile_hit(self)
		target_player.heal.rpc(damage*0.1)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == null or area.owner == null: return
	enemys[area.owner] = true
	
func _on_hitbox_area_exited(area: Area2D) -> void:
	if area == null or area.owner == null: return
	enemys.erase(area.owner)
