extends Node

signal beat_bpm_hit()
@onready var music_macro_manager = $".."

var elapsed = 0

func _process(delta):
	if not music_macro_manager.playing or music_macro_manager.is_preroll():
		return
		
	var bpm = music_macro_manager.bpm
	var seconds_per_beat = 1 / (bpm / 60)

	elapsed += delta
	if elapsed >= seconds_per_beat:
		elapsed -= seconds_per_beat
		beat_bpm_hit.emit()
	
