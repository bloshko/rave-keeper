extends Node

signal beat_hit(beat_num: int)
signal prebeat_hit(beat_num: int)
signal musik_ded

@onready var main_track = $MainTrack
@onready var pre_tick = $PreTick
@onready var track_loader = $TrackLoader

@export var move_step: int

var track_data: TrackData
var seconds_per_beat: float
var elapsed: float = 0
var beat: int = -8
var bpm = 120

# timestamp when music started playing in milliseconds since the engine start
var music_started_timestamp_msec: int = 0

var playing: bool = false
var prebeat_emitted: bool = false

func _ready() -> void:
	track_loader.track_ready.connect(_track_ready)
	var tween = create_tween()
	tween.tween_interval(4)
	tween.chain().tween_callback(func(): track_loader.load_track())

func _track_ready(data: TrackData):
	track_data = data
	pre_tick.pitch_scale = 0.7 + (beat + 8) * .03
	pre_tick.play()
	prebeat_hit.emit(beat)
	beat_hit.emit(beat)
	playing = true

func is_preroll() -> bool: return beat < 0

func _process(delta: float) -> void:
	if playing:
		bpm = track_data.get_bpm(beat)
		var subdiv = track_data.get_subdiv(beat)

		seconds_per_beat = 1 / (subdiv * (bpm / 60)) 
		elapsed += delta
		
		if elapsed + .15 >= seconds_per_beat and not prebeat_emitted:
			prebeat_hit.emit(beat + 1)
			prebeat_emitted = true
		
		if elapsed >= seconds_per_beat:
			beat += 1
			elapsed -= seconds_per_beat
			prebeat_emitted = false
			beat_hit.emit(beat)

			if is_preroll():
				pre_tick.pitch_scale = 0.7 + (beat + 8) * .02
				pre_tick.play()
			if beat == 0:
				main_track.play()
				main_track.finished.connect(func(): musik_ded.emit())
				music_started_timestamp_msec = Time.get_ticks_msec()

func get_playback_position_ms():
	# https://docs.godotengine.org/en/stable/classes/class_audioserver.html#class-audioserver-method-get-time-since-last-mix
	var playback_position_s = main_track.get_playback_position() + AudioServer.get_time_since_last_mix()
	var playback_position_ms = playback_position_s * 1000
	
	return playback_position_ms

func get_playback_position_since_engine_start_ms():
	return music_started_timestamp_msec + get_playback_position_ms()
