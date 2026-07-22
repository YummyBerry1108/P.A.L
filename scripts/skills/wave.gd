extends Projectile

"Note: the hitbox of weapon close the Monitorable property"
"""
環繞之浪：
1.攻擊：在周圍形成圓形的緩速打擊傷害(傷害比較低)
2.升級路線：圓形範圍增加、緩速量增加、傷害提升並且吸血(傷害增加量也比較低)
"""

@onready var cooldown_timer: Timer = $CooldownTimer

var enemys: Dictionary # record enemy in the hitbox of this weapon

func _ready() -> void:
	rotation = 0
	if hitbox:
		hitbox.area_entered.connect(_on_hurt_box_aera_entered)
		
func _physics_process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("players")
	var local_player: Player # the player who shoot this projectile
	for player: Player in players:
		if player.name == str(shooter_id): 
			local_player = player
			
	global_position = local_player.global_position
	move_and_slide()

func _on_cooldown_timer_timeout() -> void:
	for enemy in enemys:
		if enemy == null:
			enemys.erase(enemy)
			continue
		var damage_component: DamageComponent = enemy.damage_component
		if(damage_component == null): print("Damage Component disappear!")
		else: damage_component.process_projectile_hit(self)

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == null: return
	enemys[area.owner] = true
	
func _on_hitbox_area_exited(area: Area2D) -> void:
	if area == null: return
	enemys.erase(area.owner)
