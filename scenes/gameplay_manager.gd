extends Node

signal something_changed

@onready var gboy = $"../GBoy"
@onready var enemy_manager = $"../EnemyManager"
@onready var music_manager = $"../MusicManager"
@onready var bell = $AudioStreamPlayer

var kills: int = 0
var fails: int = 0

func _ready() -> void:
	music_manager.beat_hit.connect(_beat_hit)

func _beat_hit(new_beat: int):
	if new_beat in music_manager.track_data.evil_events:
		var lane = music_manager.track_data.evil_events[new_beat]
		if lane == gboy.current_pos:
			kills += 1
			bell.pitch_scale = 1
			bell.play()
			something_changed.emit()
		else:
			fails += 1
			bell.pitch_scale = .7
			bell.play()
			something_changed.emit()
