extends Node3D

@export var beat_micro_manager: Node
@onready var tombsA = $tomb
@onready var tombsB = $tomb2

var initial_scale_tombsA = Vector3()
var initial_scale_tombsB = Vector3()
const tomb_beat_final_scale = Vector3(1, 1, 1.2)

func _ready():
	assert("beat_bpm_hit" in beat_micro_manager)
	
	initial_scale_tombsA = tombsA.scale
	initial_scale_tombsB = tombsB.scale
	
	beat_micro_manager.beat_bpm_hit.connect(funky_tombs)
	

func funky_tombs():
	var tweenA = create_tween()
	tweenA.tween_property(tombsA, "scale", initial_scale_tombsA * tomb_beat_final_scale, .1)
	tweenA.chain().tween_property(tombsA, "scale", initial_scale_tombsA, .4)

	var tweenB = create_tween()
	tweenB.tween_property(tombsB, "scale", initial_scale_tombsB * tomb_beat_final_scale, .1)
	tweenB.chain().tween_property(tombsB, "scale", initial_scale_tombsB, .4)

	
	
