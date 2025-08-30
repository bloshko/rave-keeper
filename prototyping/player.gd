extends Node2D

@onready var sprite = $Sprite2D

var slots: Array
var slot_idx: int = 1

func _ready() -> void:
	slots = $"../Slots".get_children() as Array
	update_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_left'):
		slot_idx = clampi(slot_idx - 1, 0, 2)
		update_position()
	if event.is_action_pressed('ui_right'):
		slot_idx = clampi(slot_idx + 1, 0, 2)
		update_position()

func update_position():
	global_position = slots[slot_idx].global_position
	var tween = create_tween()

	sprite.self_modulate = Color.WHITE * 1.3
	tween.tween_property(sprite, 'self_modulate', Color.WHITE, .2)
