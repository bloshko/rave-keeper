extends Control

@onready var kills_label = $Kills
@onready var fails_label = $Fails
@onready var gpman = $"../GameplayManager"

func _ready() -> void:
	gpman.something_changed.connect(refresh)
	refresh()

func refresh():
	kills_label.text = "Kills: %d" % gpman.kills
	fails_label.text = "Fails: %d" % gpman.fails
