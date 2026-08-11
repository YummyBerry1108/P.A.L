extends Projectile

"Note: the hitbox of weapon close the Monitorable property"
"""
環繞之浪：
1. 攻擊：在周圍形成圓形的緩速打擊傷害(傷害比較低)
2. 升級路線：圓形範圍增加、緩速量增加、傷害提升並且吸血(傷害增加量也比較低)
"""

@onready var cooldown_timer: Timer = $CooldownTimer

var skill_data: SkillData = null
var enemys: Dictionary = {} # record enemy in the hitbox of this weapon

func _ready() -> void:
	rotation = 0
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_area_entered)
		hitbox.area_exited.connect(_on_hurt_box_area_exited)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	_setup_skill_data()

func _physics_process(delta: float) -> void:

	if is_instance_valid(actor):
		global_position = actor.global_position
	else:
		_before_lifespan_expired()
		queue_free()

func _setup_skill_data() -> void:
	if not actor or not actor.skills.has("wave"):
		push_warning("環繞之浪找不到玩家或SkillData")
		return
	skill_data = actor.skills["wave"]
	if skill_data.has_signal("skill_updated"):
		skill_data.skill_updated.connect(apply_skill_data)
	apply_skill_data()

func apply_skill_data() -> void:
	if not skill_data:
		return
		
	damage = skill_data.projectile_damage + actor.player_stat.damage
	cooldown_timer.wait_time = skill_data.cooldown
	scale = Vector2.ONE * skill_data.scale
	status_effects = skill_data.status_effects
	for effect: StatusEffectRes in status_effects:
		if effect is LifeStealEffect:
			effect.damage_dealt = damage
			effect.healer = actor

func _on_cooldown_timer_timeout() -> void:
	if not multiplayer.is_server():
		return
	damage = skill_data.projectile_damage + actor.player_stat.damage
	var current_enemies = enemys.keys().duplicate()
	for enemy in current_enemies:
		if not is_instance_valid(enemy):
			enemys.erase(enemy)
			continue
			
		var damage_component: DamageComponent = enemy.get("damage_component")
		if damage_component == null: 
			print("Enemy Damage Component disappear!")
			return
		damage_component.process_projectile_hit(self)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area == null or area.owner == null: return
	enemys[area.owner] = true
	
func _on_hurt_box_area_exited(area: Area2D) -> void:
	if area == null or area.owner == null: return
	enemys.erase(area.owner)
