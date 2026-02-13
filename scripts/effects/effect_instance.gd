class_name EffectInstance

var data: StatusEffectRes
var time_left: float
var tick_timer: float = 0.0

func _init(_data: StatusEffectRes):
	data = _data
	time_left = data.duration
	tick_timer = 1.0
