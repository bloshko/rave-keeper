extends Node3D

@export var gspots: Array[Node3D]

var hold_mode: bool = false

var left_pressed: bool
var right_pressed: bool
var last_pressed: GPos

var current_pos: GPos = GPos.Mid

enum GPos{
	Left = 0,
	Mid = 1,
	Right = 2
}

func _ready() -> void:
	assert(len(gspots) == 3)

func _input(event: InputEvent) -> void:
	if not hold_mode:
		if event.is_action_pressed('ui_left'):
			last_pressed = GPos.Left
		if event.is_action_pressed('ui_right'):
			last_pressed = GPos.Right
		if event.is_action_pressed('ui_down'):
			last_pressed = GPos.Mid
		if event.is_action_pressed('ui_text_backspace'):
			$"/root/Mainmenu".back()
		update_position()
		return

	if event.is_action_pressed('ui_left'):
		left_pressed = true
		last_pressed = GPos.Left
	if event.is_action_pressed('ui_right'):
		right_pressed = true
		last_pressed = GPos.Right
	if event.is_action_released('ui_left'):
		left_pressed = false
	if event.is_action_released('ui_right'):
		right_pressed = false

	update_position()

func update_position():
	if not hold_mode:
		if current_pos != last_pressed:
			global_position = gspots[last_pressed].global_position
			current_pos = last_pressed
		return

	var new_pos: GPos = GPos.Mid
	
	if not left_pressed and not right_pressed:
		new_pos = GPos.Mid
	else:
		new_pos = last_pressed

		if new_pos == GPos.Left and not left_pressed:
			new_pos == GPos.Right
		if new_pos == GPos.Right and not right_pressed:
			new_pos == GPos.Left

	if new_pos != current_pos:
		global_position = gspots[new_pos].global_position
		current_pos = new_pos
