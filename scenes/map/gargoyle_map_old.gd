extends Node3D

@onready var music_manager = $"../MusicManager"

func _ready() -> void:
	music_manager.beat_hit.connect(_beat_hit)

func _beat_hit(_new_beat):
	scale = Vector3.ONE * 1.002
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector3.ONE, .2)
