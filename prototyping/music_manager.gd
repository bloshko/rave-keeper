extends Node

signal beat_hit(beat_num: int)

@onready var main_track = $MainTrack
@onready var pre_tick = $PreTick
@onready var track_loader = $TrackLoader

@export var move_step: int

var track_data: TrackData
var seconds_per_beat: float
var elapsed: float = 0
var beat: int = -8

var playing: bool = false

func _ready() -> void:
	track_loader.track_ready.connect(_track_ready)
	var tween = create_tween()
	tween.tween_interval(4)
	tween.chain().tween_callback(func(): track_loader.load_track())

func _track_ready(data: TrackData):
	track_data = data
	pre_tick.pitch_scale = 0.7 + (beat + 8) * .03
	pre_tick.play()
	beat_hit.emit(beat)
	playing = true

func is_preroll() -> bool: return beat < 0

func _process(delta: float) -> void:
	if playing:
		var bpm = track_data.get_bpm(beat)
		var subdiv = track_data.get_subdiv(beat)

		seconds_per_beat = 1 / (subdiv * (bpm / 60)) 
		elapsed += delta
		
		if elapsed >= seconds_per_beat:
			beat += 1
			elapsed -= seconds_per_beat
			beat_hit.emit(beat)

			if is_preroll():
				pre_tick.pitch_scale = 0.7 + (beat + 8) * .02
				pre_tick.play()
			if beat == 0:
				main_track.play()
