extends Node3D

@export var direction_to_finish: Vector3

func _ready():
	pass

func _process(delta):
	pass

func die():
	queue_free()
