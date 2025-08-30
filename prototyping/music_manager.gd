extends Node

signal beat

@onready var music_back = $Backing
@onready var music_sting = $Stings
@onready var indicator = $"../Icon"

@export var move_step: int

const bpm: float = 116

var seconds_per_beat: float
var elapsed: float
var current_beat = 1
var music_events: Dictionary = {}

func _ready() -> void:
	seconds_per_beat = move_step / (bpm / 60)
	$"../MusicEventParser".music_events_parsed.connect(_on_receive_parsed_music_events)

func _on_receive_parsed_music_events(parsed_music_events: Dictionary):
	music_events = parsed_music_events

func _process(delta: float) -> void:
	# Start the song here, so we know the exact tick it's called
	if not music_back.playing and not music_events.is_empty():
		music_back.play()
		music_sting.play()
		music_sting.volume_linear = 0
		flash_indicator()
		elapsed = 0
	
	if music_back.playing:
		elapsed += delta
		if elapsed >= seconds_per_beat:
			flash_indicator()
			elapsed -= seconds_per_beat 
			current_beat += 1

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
