extends Control

@onready var kills_label = $Kills
@onready var fails_label = $Fails
@onready var bpm_label = $BPMLabel
@onready var sub_label = $SubdivisionLabel
@onready var combo_label = $ComboLabel
@onready var multi_label = $MultiLabel
@onready var gpman = $"../GameplayManager"
@onready var score_label = $ScoreBg/Score
@onready var music_man = $"../MusicManager"
@onready var combo_bar = $MultiplyerProgressBar/comboBar

@onready var skulls: Node2D = $Skulls

func _ready() -> void:
	gpman.something_changed.connect(refresh)
	music_man.beat_hit.connect(skulls.on_beat)
	music_man.beat_hit.connect(func (_new_beat): refresh())
	refresh()

func refresh():
	var beat = music_man.beat
	kills_label.text = "Kills: %d" % gpman.kills
	fails_label.text = "Fails: %d" % gpman.fails
	score_label.text = str(gpman.score)
	combo_label.text = "Combo: x%d" % gpman.combo
	multi_label.text = "x%d" % gpman.multiplier
	
	combo_bar.value = gpman.combo % 8
	
	#bounce_multi_label()

	if gpman.combo <= 8:
		combo_bar.modulate = Color("5C544B")
	else:
		combo_bar.modulate = Color("9D9183")


	if music_man.track_data:
		bpm_label.text = "BPM: %d" % int(music_man.track_data.get_bpm(beat))
		sub_label.text = "Subdivision: %s" % subdiv_text(beat)

func subdiv_text(beat) -> String:
	var subdiv = music_man.track_data.get_subdiv(beat)
	if subdiv < 1:
		return "1/2"
	else:
		return str(int(subdiv))
		
func bounce_multi_label():
	var tween = create_tween()
	tween.tween_property(multi_label, "scale", Vector2(1.3, 1.3), 0.1)
	tween.chain().tween_property(multi_label, "scale", Vector2(1, 1), 0.1)
