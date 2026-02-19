class_name EffectInstance

var data: StatusEffectRes
var time_left: float
var tick_timer: float = 0.0
var ticks_left: int = 0

func _init(_data: StatusEffectRes):
	data = _data
	time_left = data.duration
	
	ticks_left = floor(data.duration / data.tick_interval)
	
	tick_timer = data.tick_interval

func on_refresh() -> void:
	time_left = data.duration
	
	ticks_left = floor(data.duration / data.tick_interval)
