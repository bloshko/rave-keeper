class_name TapData
extends Resource

var tap_time: float = 0
var lane_num: int = 0

func _init(tap_time: float, lane_num: int):
	self.tap_time = tap_time
	self.lane_num = lane_num
