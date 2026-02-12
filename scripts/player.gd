extends CharacterBody2D

@export var projectile: PackedScene
@export var damage: float = 10.0

const SPEED: float = 300.0
var skills: Dictionary = {}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pull_skills()
	fetch_behavior("Attack", { "player": self, "skills": skills })

func _physics_process(delta: float) -> void:
	fetch_behavior("Movement", { "player": self, "SPEED": SPEED, "delta": delta })
	move_and_slide()

func fetch_behavior(name: String, args):
	get_node_or_null("Behaviors/" + name).run(args)

func pull_skills():
	for child: Node in get_node("Skills").get_children():
		skills[child.name] = child
