extends Node3D
@onready var animation = $human_a/AnimationPlayer

enum STATE {
	WALKING,
	RUNNING_AWAY
}

var state = STATE.WALKING

func _ready():
	animation.play("Armature|danceA", 0.0, 1.0)

func scare():
	animation.play("scared")
	animation.animation_set_next("run")
