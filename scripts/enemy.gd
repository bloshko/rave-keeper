extends Node3D

var age: int = 0

func jump_to(target: Vector3):
	global_position = target

func die():
	queue_free()
