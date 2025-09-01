extends Node

signal beat_hit_halved()
@onready var music_macro_manager = $".."

var elapsed = 0

func _process(delta):
	if not music_macro_manager.playing or music_macro_manager.is_preroll():
		return
		
	var seconds_per_beat_half = music_macro_manager.seconds_per_beat / 2
	
	elapsed += delta
	if elapsed >= seconds_per_beat_half:
		elapsed -= seconds_per_beat_half
		beat_hit_halved.emit()
	
