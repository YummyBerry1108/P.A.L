extends Node

@onready var shooting_helper_scene = preload("res://scenes/player/shoot.tscn")

var cooldowns: Dictionary[String, float] = {}

func run(args: Dictionary) -> void:
	if not is_multiplayer_authority():
		return
	if Input.is_action_pressed("shoot"):
		cooldown(args["player"], args["skills"])

func cooldown(player: CharacterBody2D, skills: Dictionary) -> void:
	var now_time = Time.get_unix_time_from_system()
	for skill_name in skills:
		var skill_scene_name: String = "res://scenes/skills/" + skill_name + ".tscn"
		var skill_data : SkillData = skills[skill_name]
		if not cooldowns.has(skill_name) or now_time >= cooldowns[skill_name]:
			cooldowns[skill_name] = now_time + (1 / skill_data.firerate)
			how_to_shoot(player, skill_data, skill_scene_name)

func how_to_shoot(player: CharacterBody2D, skill_data: SkillData, skill_scene_name: String) -> void:
	if skill_data.attack_type == "Single":
		var rotations = calculate_directions(player.global_position, player.get_global_mouse_position(), skill_data.projectile_count, min(skill_data.arc + skill_data.arc_increment * skill_data.projectile_count, 360))
		#print(rotations)
		for rot in rotations:
			#print("ROT : ", rot)
			var shooting_helper: ShootingHelper = shooting_helper_scene.instantiate()
			add_child(shooting_helper, true)
			shooting_helper.set_shoot_timer(0.1, skill_data.multishot, player.global_position, rot, skill_scene_name, player.damage)
	elif skill_data.attack_type == "Burst":
		pass
	elif skill_data.attack_type == "Shotgun":
		pass

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
