extends Node3D


@onready var particle = $Enemy/ParticleFeedback


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_down"):
		trigger()
	
	
func trigger():
	particle.restart()
	pass
