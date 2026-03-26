extends Node

const MAX_SFX_PLAYERS = 15

@export var bgm: AudioStreamPlayer

var _bgm_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _bgm_tween: Tween

func _ready() -> void:
	_init_bgm_player()
	_init_sfx_pool()

func _init_bgm_player() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "BGM"
	add_child(_bgm_player)

func _init_sfx_pool() -> void:
	for i in range(MAX_SFX_PLAYERS):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_sfx_pool.append(player)

# 播放背景音樂 (支援淡入淡出)
func play_bgm(stream: AudioStream, fade_duration: float = 1.0) -> void:
	if _bgm_player.stream == stream and _bgm_player.playing:
		return
		
	if _bgm_tween:
		_bgm_tween.kill()
		
	_bgm_tween = create_tween()
	
	if _bgm_player.playing:
		# 舊音樂淡出
		_bgm_tween.tween_property(_bgm_player, "volume_db", -80.0, fade_duration / 2.0)
		_bgm_tween.tween_callback(func(): _start_new_bgm(stream, fade_duration))
	else:
		_start_new_bgm(stream, fade_duration)

func _start_new_bgm(stream: AudioStream, fade_duration: float) -> void:
	_bgm_player.stream = stream
	_bgm_player.volume_db = -80.0
	_bgm_player.play()
	# 新音樂淡入
	_bgm_tween.tween_property(_bgm_player, "volume_db", 0.0, fade_duration / 2.0)

# 停止背景音樂
func stop_bgm(fade_duration: float = 1.0) -> void:
	if not _bgm_player.playing: return
	
	if _bgm_tween:
		_bgm_tween.kill()
	_bgm_tween = create_tween()
	_bgm_tween.tween_property(_bgm_player, "volume_db", -80.0, fade_duration)
	_bgm_tween.tween_callback(_bgm_player.stop)

# 播放音效 (支援隨機音調變化以降低聽覺疲勞)
func play_sfx(stream: AudioStream, pitch_variance: float = 0.0, volume_db: float = 0.0) -> void:
	for player in _sfx_pool:
		if not player.playing:
			player.stream = stream
			player.volume_db = volume_db
			
			if pitch_variance > 0.0:
				player.pitch_scale = 1.0 + randf_range(-pitch_variance, pitch_variance)
			else:
				player.pitch_scale = 1.0
				
			player.play()
			return
			
	push_warning("SFX Pool is full. Consider increasing MAX_SFX_PLAYERS.")
