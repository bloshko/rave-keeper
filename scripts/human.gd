extends Node3D
@onready var animation = $human_a/AnimationPlayer

enum STATE {
	WALKING,
	RUNNING_AWAY
}

var age = 0

var state = STATE.WALKING
var max_offset_radius: float = .1

var run_away_direction = Vector3.BACK
var velocity = 5

@onready var mesh = $Cylinder

func jump_to(target: Vector3):
	if state != STATE.WALKING:
		return

	var tween = create_tween()
	var offset_x = -max_offset_radius + randf() * max_offset_radius * 2
	var offset_z = -max_offset_radius + randf() * max_offset_radius * 2

	tween.tween_property(self, 'global_position', target + Vector3(offset_x, 0, offset_z), .2)

func _ready():
	animation.play("Armature|danceA", 0.0, 1.0)

func _process(delta):
	if state == STATE.RUNNING_AWAY:
		position += run_away_direction * velocity * delta

func scare_away():
	state = STATE.RUNNING_AWAY
	look_at(run_away_direction, Vector3.UP)
	animation.play("run")
	
	animation.animation_finished.connect(_die)

func _die():
	queue_free()
