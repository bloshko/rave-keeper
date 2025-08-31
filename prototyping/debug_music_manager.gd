extends Node

@onready var audio_player = $AudioStreamPlayer
@onready var track_loader = $TrackLoader
@onready var indicator = $"../Icon"

var track_data: TrackData
var seconds_per_beat: float
var elapsed: float = 0
var beat: int

func _ready() -> void:
	track_loader.track_ready.connect(_track_ready)
	track_loader.load_track()

func _track_ready(data: TrackData):
	track_data = data
	audio_player.play()
	beat = 0
	flash_indicator()

func flash_indicator():
	indicator.self_modulate = Color.WHITE * 1.5
	var tween = create_tween()
	tween.tween_property(indicator, 'self_modulate', Color.WHITE, .1)

func _process(delta: float) -> void:
	if audio_player.playing:
		var bpm = track_data.get_bpm(beat)
		var subdiv = track_data.get_subdiv(beat)

		seconds_per_beat = 1 / (subdiv * (bpm / 60)) 
		elapsed += delta
		
		if elapsed >= seconds_per_beat:
			beat += 1
			flash_indicator()
			print(beat)

			elapsed -= seconds_per_beat 
