extends Node3D

@onready var lane_starts = [
	$"../Lanes/Lane1/StartLane",
	$"../Lanes/Lane2/StartLane",
	$"../Lanes/Lane3/StartLane"
]

@onready var lane_ends = [
	$"../Lanes/Lane1/FinishLane",
	$"../Lanes/Lane2/FinishLane",
	$"../Lanes/Lane3/FinishLane"
]

@onready var lane_enemies = [
	$"../Lanes/Lane1/Enemies",
	$"../Lanes/Lane2/Enemies",
	$"../Lanes/Lane3/Enemies"
]

@onready var music_manager = $"../MusicManager"

@export var enemy_scene: PackedScene

var lane_directions = [
	Vector3.FORWARD,
	Vector3.FORWARD,
	Vector3.FORWARD
]

var step_lengths = [
	0,
	0,
	0
]

const look_ahead: int = 4;

func _ready():
	for i in range(3):
		lane_directions[i] = (lane_ends[i].global_position - lane_starts[i].global_position).normalized();
		step_lengths[i] = lane_starts[i].global_position.distance_to(lane_ends[i].global_position) / look_ahead

	music_manager.beat_hit.connect(_beat_hit)
	
func _beat_hit(new_beat: int):	
	move_enemies()

	var spawn_beat = new_beat + look_ahead
	if spawn_beat in music_manager.track_data.evil_events:
		spawn_enemy(music_manager.track_data.evil_events[spawn_beat])

func spawn_enemy(lane_idx: int):
	var spawn_position = lane_starts[lane_idx].global_position
	var parent_node = lane_enemies[lane_idx]

	var enemy = enemy_scene.instantiate()
	
	parent_node.add_child(enemy)
	enemy.global_position = spawn_position;

func move_enemies():
	for i in range(3):
		for child in lane_enemies[i].get_children():
			child.age += 1 
			child.jump_to(lane_starts[i].global_position + lane_directions[i] * step_lengths[i] * child.age)
