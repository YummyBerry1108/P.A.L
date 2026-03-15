extends Enemy

@export var fire_trail_scene: PackedScene

@onready var state_timer: Timer = $StateTimer

@export var dash_speed: float = 900.0
@export var target_duration: float = 0.5
@export var lock_duration: float = 0.5 
@export var dash_duration: float = 1
@export var idle_duration: float = 0.5


func _ready() -> void:
	super()
	speed = 250
