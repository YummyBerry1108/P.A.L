extends Projectile

"Note: the hitbox of weapon close the Monitorable property"
"""
環繞之浪：
1. 攻擊：在周圍形成圓形的緩速打擊傷害(傷害比較低)
2. 升級路線：圓形範圍增加、緩速量增加、傷害提升並且吸血(傷害增加量也比較低)
"""

@onready var cooldown_timer: Timer = $CooldownTimer

var enemys: Dictionary = {} # record enemy in the hitbox of this weapon

func _ready() -> void:
	rotation = 0
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_area_entered)
		hitbox.area_exited.connect(_on_hurt_box_area_exited)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	skill_data.skill_updated.connect(apply_skill_data)
	apply_skill_data()

func _physics_process(delta: float) -> void:
	if is_instance_valid(actor):
		global_position = actor.global_position
	else:
		_before_lifespan_expired()
		queue_free()

func apply_skill_data() -> void:
	if not skill_data or not is_instance_valid(actor):
		return
		
	damage = skill_data.projectile_damage + actor.player_stat.damage
	cooldown_timer.wait_time = skill_data.cooldown
	scale = Vector2.ONE * skill_data.scale

func _on_cooldown_timer_timeout() -> void:
	if not multiplayer.is_server():
		return
	damage = skill_data.projectile_damage + actor.player_stat.damage
	hit_count = 0
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
