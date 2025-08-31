extends Node3D

@onready var lane_start_1 = $"../Lanes/Lane1/StartLane"
@onready var lane_start_2 = $"../Lanes/Lane2/StartLane"
@onready var lane_start_3 = $"../Lanes/Lane3/StartLane"

@onready var lane_finish_1 = $"../Lanes/Lane1/FinishLane"
@onready var lane_finish_2 = $"../Lanes/Lane2/FinishLane"
@onready var lane_finish_3 = $"../Lanes/Lane3/FinishLane"

@onready var lane_enemies_1 = $"../Lanes/Lane1/Enemies"
@onready var lane_enemies_2 = $"../Lanes/Lane2/Enemies"
@onready var lane_enemies_3 = $"../Lanes/Lane3/Enemies"

@onready var music_manager = $"../MusicManager"

@export var enemy_scene: PackedScene



var lane_direction_1 = Vector3.FORWARD;
var lane_velocity_1 = 1;

var lane_direction_2 = Vector3.FORWARD;
var lane_velocity_2 = 1;

var lane_direction_3 = Vector3.FORWARD;
var lane_velocity_3 = 1;

var approach_beats = 4;

var enemies: Array = [[1, null, 1], [1, 2, null],[null, 3, 3], [1, null, 1],]

func _ready():
	# todo: use bpm from parsed data
	var bpm = music_manager.bpm
	 
	var time_to_finish = approach_beats * 60 / bpm; # 5 is approach_beats
	
	lane_direction_1 = (lane_finish_1.global_position - lane_start_1.global_position).normalized();
	lane_velocity_1 = lane_start_1.global_position.distance_to(lane_finish_1.global_position) / time_to_finish
	
	lane_direction_2 = (lane_finish_2.global_position - lane_start_2.global_position).normalized();
	lane_velocity_2 = lane_start_2.global_position.distance_to(lane_finish_2.global_position) / time_to_finish

	lane_direction_3 = (lane_finish_3.global_position - lane_start_3.global_position).normalized();
	lane_velocity_3 = lane_start_3.global_position.distance_to(lane_finish_3.global_position) / time_to_finish

	music_manager.beat.connect(_on_beat)
	
func _on_beat(beat_num: int):
	var index_to_spawn = approach_beats + beat_num
	
	if index_to_spawn < 0:
		return
	
	spawn_index(index_to_spawn)
	
func spawn_index(index_to_spawn: int):
	spawn_enemy(1)
	if enemy_scene == null or index_to_spawn + 1 > enemies.size():
		return
		
	var enemies_to_spawn = enemies[index_to_spawn]
	
	#if enemies_to_spawn[0]:
		#spawn_enemy(1)
		
	if enemies_to_spawn[1]:
		spawn_enemy(2)

	if enemies_to_spawn[2]:	
		spawn_enemy(3)


func spawn_enemy(lane_num: int):
	var spawn_position = lane_start_3.global_position
	var parent_node = lane_enemies_3
	
	if lane_num == 1:
		spawn_position = lane_start_1.global_position
		parent_node = lane_enemies_1
	elif lane_num == 2:
		spawn_position = lane_start_2.global_position
		parent_node = lane_enemies_2
		
	var enemy = enemy_scene.instantiate()
	music_manager.beat.connect(enemy._on_beat)

	parent_node.add_child(enemy)
	enemy.global_position = spawn_position;

	
func _process(delta):
	for child in lane_enemies_1.get_children():
		child.global_position += lane_direction_1 * delta * lane_velocity_1		
	for child in lane_enemies_2.get_children():
		child.global_position += lane_direction_2 * delta * lane_velocity_2		
	for child in lane_enemies_3.get_children():
		child.global_position += lane_direction_3 * delta * lane_velocity_3	
