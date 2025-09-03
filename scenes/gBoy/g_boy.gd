extends Node3D

@export var gspots: Array[Node3D]

signal gBoy_tap(tap_data: TapData)

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

const left_lane_action_name = "move_to_left_lane"
const mid_lane_action_name = "move_to_mid_lane"
const right_lane_action_name = "move_to_right_lane"


func _ready() -> void:
	assert(len(gspots) == 3)

func tap(lane_num: GPos):
	last_pressed = lane_num
	# todo: use correct time
	var tap_data = TapData.new(0, last_pressed)

	
	gBoy_tap.emit(tap_data)
	
func _input(event: InputEvent) -> void:
	if not hold_mode:
		if event.is_action_pressed(left_lane_action_name):
			tap(GPos.Left)
		if event.is_action_pressed(right_lane_action_name):
			tap(GPos.Right)
		if event.is_action_pressed(mid_lane_action_name):
			tap(GPos.Mid)
		if event.is_action_pressed('ui_text_backspace'):
			$"/root/Mainmenu".back()
		update_position()
		return

	if event.is_action_pressed(left_lane_action_name):
		left_pressed = true
		last_pressed = GPos.Left
	if event.is_action_pressed(right_lane_action_name):
		right_pressed = true
		last_pressed = GPos.Right
	if event.is_action_released(left_lane_action_name):
		left_pressed = false
	if event.is_action_released(right_lane_action_name):
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
