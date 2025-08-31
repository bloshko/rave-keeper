extends Node3D

@onready var mesh = $ghost

var age: int = 0

var max_offset_radius: float = .1

func jump_to(target: Vector3):
	var tween = create_tween()
	var offset_x = -max_offset_radius + randf() * max_offset_radius * 2
	var offset_z = -max_offset_radius + randf() * max_offset_radius * 2

	tween.tween_property(self, 'global_position', target + Vector3(offset_x, 0, offset_z), .2)

	var jump_tween = create_tween()
	jump_tween.tween_property(mesh, 'position', Vector3(0, .1 + randf() * .3 , 0), .1)
	jump_tween.chain().tween_property(mesh, 'position', Vector3.ZERO, .1)

func die():
	queue_free()
