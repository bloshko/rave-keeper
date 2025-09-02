extends MeshInstance3D

var initial_position: Vector3

func _ready() -> void:
	initial_position = global_position

func jump():
	var tween = create_tween()
	tween.tween_property(self, 'global_position', initial_position + Vector3(0, .3, 0), .05)
	tween.chain().tween_property(self, 'global_position', initial_position, .2)
