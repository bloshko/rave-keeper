extends Node2D

#@onready var game_ui = $".."
var initial_rotations = []
var is_going_clockwise = true

func _ready():
	#game_ui.music_man.beat_hit.connect(_on_beat)
	var children = get_children()
	for i in range(len(children)):
		initial_rotations.append(0)
		
	for child in get_children():
		print(child.get_index())
		initial_rotations[child.get_index()] = child.rotation_degrees

func on_beat(beat_num: int):
	for child in get_children():
		var initial_rotation = initial_rotations[child.get_index()]
		
		if child.rotation_degrees == initial_rotation:
			child.rotation_degrees -= -15 if (is_going_clockwise) else 15
			is_going_clockwise = !is_going_clockwise
		else:
			child.rotation_degrees = initial_rotation
