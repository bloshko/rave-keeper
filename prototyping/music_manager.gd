extends Node

signal beat

@onready var music_back = $Backing
@onready var music_sting = $Stings
@onready var indicator = $"../Icon"

@export var move_step: int

const bpm: float = 116

var seconds_per_beat: float
var elapsed: float

func _ready() -> void:
	seconds_per_beat = move_step / (bpm / 60)

func _process(delta: float) -> void:
	# Start the song here, so we know the exact tick it's called
	if not music_back.playing:
		music_back.play()
		music_sting.play()
		music_sting.volume_linear = 0
		flash_indicator()
		elapsed = 0
	else:
		elapsed += delta
		if elapsed >= seconds_per_beat:
			flash_indicator()
			elapsed -= seconds_per_beat 

func flash_indicator():
	indicator.self_modulate = Color.WHITE * 1.5
	var tween = create_tween()
	tween.tween_property(indicator, 'self_modulate', Color.WHITE, .1)
	beat.emit()

func sting():
	if not music_sting:
		return

	music_sting.volume_linear = 1.0
	var tween = create_tween()
	tween.tween_interval(.2)
	tween.chain().tween_property(music_sting, 'volume_linear', 0, .1)
