extends Node

signal something_changed

@onready var gboy = $"../GBoy"
@onready var enemy_manager = $"../EnemyManager"
@onready var music_manager = $"../MusicManager"
@onready var bell = $AudioStreamPlayer
@onready var finish_line = $"../finish2"

var kills: int = 0
var fails: int = 0
var score: int = 0
var multiplier: float = 1
var combo: int = 0

var wait_time: float = .02
var game_over: bool = false

func _ready() -> void:
	music_manager.beat_hit.connect(_beat_hit)

func _beat_hit(new_beat: int):
	if game_over:
		return

	var tween = create_tween()
	tween.tween_interval(wait_time)
	tween.chain().tween_callback(func(): check_kill(new_beat))

func check_kill(beat: int):
	if beat in music_manager.track_data.evil_events:
		var lane = music_manager.track_data.evil_events[beat]
		if lane == gboy.current_pos:
			kills += 1
			bell.pitch_scale = 1
			combo += 1
			multiplier = 1 + floor(combo / 8.0)
			score += 100 * multiplier
			finish_line.jump()
			bell.play()
			something_changed.emit()
		else:
			fails += 1
			bell.pitch_scale = .5
			combo = 0
			multiplier = 1 + floor(combo / 8.0)
			bell.play(.02)
			something_changed.emit()

			if GameplayData.hardcore and fails > 4:
				game_over = true
				var tween = create_tween()
				tween.tween_property(music_manager.main_track, 'pitch_scale', 0.5, 10)
