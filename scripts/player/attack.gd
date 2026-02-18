extends Node

@onready var shooting_helper_scene = preload("res://scenes/player/shoot.tscn")

var cooldowns: Dictionary[String, float] = {}

func run(args: Dictionary) -> void:
	if not is_multiplayer_authority():
		return
	if Input.is_action_pressed("shoot"):
		cooldown()

#func cooldown(player: CharacterBody2D, skills: Dictionary) -> void:
func cooldown() -> void:
	var now_time = Time.get_unix_time_from_system()
	for skill_name in owner.skills:
		if owner.skills[skill_name].disable: continue
		if not cooldowns.has(skill_name) or now_time >= cooldowns[skill_name]:
			cooldowns[skill_name] = now_time + (1 / owner.skills[skill_name].firerate)
			fire_in_different_rotations(skill_name)

#func how_to_shoot(player: CharacterBody2D, skill_data: SkillData, skill_scene_name: String) -> void:
func fire_in_different_rotations(skill_name: String) -> void:
	var skill_data = owner.skills[skill_name] as SkillData
	var rotations = calculate_directions(owner.global_position, owner.get_global_mouse_position(), skill_data.projectile_count, min(skill_data.arc + skill_data.arc_increment * skill_data.projectile_count, 360))
	#print(rotations)
	for rot in rotations:
		#print("ROT : ", rot)
		create_shooting_helper.rpc(skill_name, rot)

@rpc("any_peer", "call_local")
func create_shooting_helper(skill_name: String, rot: float) -> void:
	var skill_scene_name: String = "res://scenes/skills/" + skill_name + ".tscn"
	var skill_data = owner.skills[skill_name] as SkillData
	var shooting_helper: ShootingHelper = shooting_helper_scene.instantiate()
	
	add_child(shooting_helper, true)
	shooting_helper.set_shoot_timer(0.1, skill_data, rot, skill_scene_name)

func calculate_directions(base_position: Vector2, target: Vector2, projectile_count: int, shooting_arc: float) -> Array[float]:
	var rot = base_position.direction_to(target).angle()
	var rotations: Array[float] = []
	if projectile_count > 1:
		for i in projectile_count:
			var arc_rad = deg_to_rad(shooting_arc)
			var increment = arc_rad / (projectile_count - 1)
			rotations.append(
				rot +
				increment * i -
				arc_rad / 2
			)
	else:
		rotations.append(rot)
	return rotations
