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

@onready var lane_humans = [
	$"../Lanes/Lane1/Humans",
	$"../Lanes/Lane2/Humans",
	$"../Lanes/Lane3/Humans"
]

@onready var music_manager = $"../MusicManager"

@export var enemy_scene: PackedScene
@export var human_scene: PackedScene

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

const look_ahead: int = 8;
const has_humans = true
@onready var gBoy = $"../GBoy"

func _ready():
	for i in range(3):
		lane_directions[i] = (lane_ends[i].global_position - lane_starts[i].global_position).normalized();
		step_lengths[i] = lane_starts[i].global_position.distance_to(lane_ends[i].global_position) / look_ahead

	music_manager.beat_hit.connect(_beat_hit)
	
func _beat_hit(new_beat: int):	
	move_enemies()

	if has_humans:
		move_humans()

	var spawn_beat = new_beat + look_ahead
	var enemy_lane = -1
	
	if spawn_beat in music_manager.track_data.evil_events:
		enemy_lane = music_manager.track_data.evil_events[spawn_beat]
		spawn_enemy(enemy_lane, spawn_beat)

	if has_humans:	
		var human_lane = randi_range(0, 2)
		for i in range(3):
			if i == enemy_lane:
				continue
			if i == human_lane:
				spawn_human(i, spawn_beat)

func get_enemies_by_lane(lane_idx: int):
	return lane_enemies[lane_idx].get_children()
	
func spawn_enemy(lane_idx: int, beat_on_finish: int):
	var spawn_position = lane_starts[lane_idx].global_position
	var parent_node = lane_enemies[lane_idx]

	var enemy = enemy_scene.instantiate()
	enemy.beat_on_finish = beat_on_finish
	
	parent_node.add_child(enemy)
	enemy.global_position = spawn_position;
	

func spawn_human(lane_idx: int, beat_on_finish: int):
	var spawn_position = lane_starts[lane_idx].global_position
	var parent_node = lane_humans[lane_idx]

	var human = human_scene.instantiate()
	human.beat_on_finish = beat_on_finish

	parent_node.add_child(human)
	human.global_position = spawn_position;

func move_humans():
	for i in range(3):
		for human in lane_humans[i].get_children():
			human.age += 1 
			human.jump_to(lane_starts[i].global_position + lane_directions[i] * step_lengths[i] * human.age)
			if human.age - 2 > look_ahead: # when entered church
				human.die()

func move_enemies():
	for i in range(3):
		for child in lane_enemies[i].get_children():
			child.age += 1 
			child.jump_to(lane_starts[i].global_position + lane_directions[i] * step_lengths[i] * child.age)
			if child.age - 2 > look_ahead: # when entered church
				child.die()
