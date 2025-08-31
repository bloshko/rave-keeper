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

func _ready() -> void:
	gpman.something_changed.connect(refresh)
	music_man.beat_hit.connect(func (_new_beat): refresh())
	refresh()

func refresh():
	var beat = music_man.beat
	kills_label.text = "Kills: %d" % gpman.kills
	fails_label.text = "Fails: %d" % gpman.fails
	score_label.text = str(gpman.score)
	combo_label.text = "Combo: x%d" % gpman.combo
	multi_label.text = "Multiplier: x%d" % gpman.multiplier

	if music_man.track_data:
		bpm_label.text = "BPM: %d" % int(music_man.track_data.get_bpm(beat))
		sub_label.text = "Subdivision: %s" % subdiv_text(beat)

func subdiv_text(beat) -> String:
	var subdiv = music_man.track_data.get_subdiv(beat)
	if subdiv < 1:
		return "1/2"
	else:
		return str(int(subdiv))
