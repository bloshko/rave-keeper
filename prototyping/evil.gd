extends Sprite2D

@onready var musicman = $"../../MusicManager"

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
	if step_idx == 4:
		die()

func die():
	var tween = create_tween()
	modulate = Color.WHITE * 1.3
	tween.tween_property(self, 'modulate', Color.WHITE, .2)
	musicman.sting()
