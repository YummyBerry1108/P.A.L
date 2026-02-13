extends Node

@onready var shooting_helper_scene = preload("res://scenes/player/shoot.tscn")

var cooldowns: Dictionary[String, float] = {}

func run(args: Dictionary) -> void:
	if Input.is_action_pressed("shoot"):
		cooldown(args["player"], args["skills"])

func cooldown(player: CharacterBody2D, skills: Dictionary) -> void:
	var now_time = Time.get_unix_time_from_system()
	for skill_name in skills:
		var skill_node: PackedScene = load("res://scenes/skills/" + skill_name + ".tscn")
		var skill_data : SkillData = skills[skill_name]
		if not cooldowns.has(skill_name) or now_time >= cooldowns[skill_name]:
			var new_projectile: Projectile = skill_node.instantiate()
			cooldowns[skill_name] = now_time + (1 / new_projectile.firerate)
			how_to_shoot(player, new_projectile, skill_data, skill_node)

func how_to_shoot(player: CharacterBody2D, projectile: Projectile, skill_data: SkillData, skill_node: PackedScene) -> void:
	if skill_data.attack_type == "Single":
		var rotations = calculate_directions(player.global_position, player.get_global_mouse_position(), skill_data.projectile_count, min(projectile.arc + projectile.arc_increment * skill_data.projectile_count, 360))
		#print(rotations)
		for rot in rotations:
			#print("ROT : ", rot)
			var shooting_helper: ShootingHelper = shooting_helper_scene.instantiate()
			add_child(shooting_helper)
			shooting_helper.set_shoot_timer(0.1, skill_data.multishot, player, projectile, rot, skill_node)

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
