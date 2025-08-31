extends Node3D

@onready var animation_ghost = $ghost/AnimationPlayer

func _ready():
	pass

func _on_beat(beat_num: int):
	if beat_num % 4 == 0:
		animation_ghost.play("ghosrRig|ghostHeadBobbingMore", 0.0, 3.0)
	else:
		animation_ghost.play("ghosrRig|ghostHeadBobbing", 0.0, 2.0)

func die():
	queue_free()
