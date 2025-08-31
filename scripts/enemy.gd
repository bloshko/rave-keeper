extends Node3D

@onready var mesh = $ghost

var age: int = 0

func jump_to(target: Vector3):
	var tween = create_tween()
	tween.tween_property(self, 'global_position', target, .2)

	var jump_tween = create_tween()
	jump_tween.tween_property(mesh, 'position', Vector3(0, .2, 0), .1)
	jump_tween.chain().tween_property(mesh, 'position', Vector3.ZERO, .1)

func die():
	queue_free()
