extends Sprite2D

@export var start_offset: int

var initial_pos: Vector2
var step_idx: int

func _ready() -> void:
	$"../../MusicManager".beat.connect(step)
	initial_pos = global_position
	step_idx = start_offset
	update_position()

func step():
	step_idx = (step_idx + 1) % 5
	update_position()

func update_position():
	global_position = Vector2(initial_pos.x, initial_pos.y - 96 * step_idx)
