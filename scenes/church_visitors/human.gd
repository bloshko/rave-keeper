extends Node3D
@onready var animation = $human_a/AnimationPlayer

enum STATE {
	WALKING,
	DYING
}

var age = 0

var beat_on_finish: int = 0

var state = STATE.WALKING
var max_offset_radius: float = .1

@onready var mesh = $human_a/Armature/Skeleton3D/Cylinder

func jump_to(target: Vector3):
	if state != STATE.WALKING:
		return

	var tween = create_tween()
	var offset_x = -max_offset_radius + randf() * max_offset_radius * 2
	var offset_z = -max_offset_radius + randf() * max_offset_radius * 2

	tween.tween_property(self, 'global_position', target + Vector3(offset_x, 0, offset_z), .2)

func _ready():
	animation.play("Armature|danceA")


func scare_away():
	if state != STATE.WALKING:
		return
	state = STATE.DYING
	
	animation.play("Armature|scared")
	
	var tween = create_tween()
	tween.tween_interval(.4)
	tween.chain().tween_callback(die)

func die():
	queue_free()
