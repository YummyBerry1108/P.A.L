extends Enemy

func _ready() -> void:
	super()
	speed = 100

#func _physics_process(delta: float) -> void:
	#if !multiplayer.is_server(): return
