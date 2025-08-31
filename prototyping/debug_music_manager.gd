extends Node

@onready var audio_player = $AudioStreamPlayer
@onready var track_loader = $TrackLoader
@onready var indicator = $"../Icon"
@onready var evil_indicators = [
	$"../Lanes/EvilLeft",
	$"../Lanes/EvilMiddle",
	$"../Lanes/EvilRight",
	
	$"../Lanes/EvilLeft2",
	$"../Lanes/EvilMiddle2",
	$"../Lanes/EvilRight2",
	
	$"../Lanes/EvilLeft3",
	$"../Lanes/EvilMiddle3",
	$"../Lanes/EvilRight3",
	
	$"../Lanes/EvilLeft4",
	$"../Lanes/EvilMiddle4",
	$"../Lanes/EvilRight4",

	$"../Lanes/EvilLeft5",
	$"../Lanes/EvilMiddle5",
	$"../Lanes/EvilRight5",
]

var track_data: TrackData
var seconds_per_beat: float
var elapsed: float = 0
var beat: int

func _ready() -> void:
	track_loader.track_ready.connect(_track_ready)
	track_loader.load_track()
	for evil_indicator in evil_indicators:
		evil_indicator.modulate = Color.TRANSPARENT

func _track_ready(data: TrackData):
	track_data = data
	audio_player.play()
	beat = 0
	flash_indicator()

func flash_indicator():
	indicator.self_modulate = Color.WHITE * 1.5
	var tween = create_tween()
	tween.tween_property(indicator, 'self_modulate', Color.WHITE, .1)

	if beat in track_data.evil_events:
		var lane = track_data.evil_events[beat]
		evil_indicators[lane].modulate = Color.WHITE
		var evil_tween = create_tween()
		evil_tween.tween_property(evil_indicators[lane], 'modulate', Color.TRANSPARENT, .2)

	# preview indicators
	for i in range(1, 5):
		for j in range(3):
			evil_indicators[i * 3 + j].modulate = Color.TRANSPARENT

		if beat + i in track_data.evil_events:
			var lane = track_data.evil_events[beat + i]
			evil_indicators[i * 3 + lane].modulate = Color.WHITE

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
