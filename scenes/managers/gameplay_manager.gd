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

var successful_tap_window_ms: float = 200

func _ready() -> void:
	gboy.gBoy_tap.connect(check_kill)
	music_manager.musik_ded.connect(func(): $"/root/Mainmenu/Gameover".blublub(score))

func _get_hit_or_miss(target_ms: float, tap_ms: float) -> HitOrMissData:
	var tap_margin = target_ms - tap_ms
	
	var hit_or_miss_data = HitOrMissData.new()
	hit_or_miss_data.margin = tap_margin

	if abs(tap_margin) > successful_tap_window_ms:
		hit_or_miss_data.status = HitOrMissData.Status.Miss
	else:
		hit_or_miss_data.status = HitOrMissData.Status.Hit
	
	return hit_or_miss_data


func check_kill(tap_data: TapData):
	if game_over:
		return
	
	var enemies = enemy_manager.get_enemies_by_lane(tap_data.lane_num)
	var tap_timestamp_ms = tap_data.tap_time
	
	var has_fail = false
	for enemy in enemies:
		var enemy_beat = enemy.beat_on_finish
		var beat_timestamp_since_engine_started_ms = music_manager.music_started_timestamp_msec + music_manager.track_data.beat_timestamps_ms[enemy_beat] 
		var hit_or_miss = _get_hit_or_miss(beat_timestamp_since_engine_started_ms, tap_timestamp_ms)
		
		if hit_or_miss.status == HitOrMissData.Status.Hit:
			if enemy.can_be_killed():
				enemy.kill()
				_count_kill()
			break
		else:
			has_fail = true

	if has_fail or len(enemies) == 0:
		_count_fail()

func _count_kill():
	kills += 1
	bell.pitch_scale = 1
	combo += 1
	multiplier = 1 + floor(combo / 8.0)
	score += 100 * multiplier
	finish_line.jump()
	something_changed.emit()

func _count_fail():
	fails += 1
	bell.pitch_scale = .5
	combo = 0
	multiplier = 1 + floor(combo / 8.0)
	something_changed.emit()

	if GameplayData.hardcore and fails > 4:
		game_over = true
		var tween = create_tween()
		tween.tween_property(music_manager.main_track, 'pitch_scale', 0.5, 10)
		$"/root/Mainmenu/Gameover".blublub(score)
