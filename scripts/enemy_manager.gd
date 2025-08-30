extends Node3D

@onready var lane_start_1 = $"../Lanes/Lane1/StartLane1"
@onready var lane_start_2 = $"../Lanes/Lane2/StartLane2"
@onready var lane_start_3 = $"../Lanes/Lane3/StartLane3"

@onready var lane_finish_1 = $"../Lanes/Lane1/FinishLane1"
@onready var lane_finish_2 = $"../Lanes/Lane2/FinishLane2"
@onready var lane_finish_3 = $"../Lanes/Lane3/FinishLane3"

@onready var music_manager = $"../MusicManager"

@export var enemy_scene: PackedScene

var lane_direction_1 = Vector3.FORWARD;
var lane_direction_2 = Vector3.FORWARD;
var lane_direction_3 = Vector3.FORWARD;

var velocity = 1.0;
var look_ahead_index = 0;

var enemies: Array = [[1, null, 1], [1, 2, null],[null, 3, 3], [1, null, 1],]

func _ready():
	lane_direction_1 = (lane_finish_1.global_position - lane_start_1.global_position).normalized();
	lane_direction_2 = (lane_finish_2.global_position - lane_start_2.global_position).normalized();
	lane_direction_3 = (lane_finish_3.global_position - lane_start_3.global_position).normalized();
	
	music_manager.beat.connect(_on_beat)
	
func _on_beat(beat_num: int):
	var index_to_spawn = look_ahead_index + (beat_num - 1)
	
	if index_to_spawn < 0:
		return
	print(beat_num)
	spawn_index(index_to_spawn)
	
func spawn_index(index_to_spawn: int):
	if enemy_scene == null or index_to_spawn + 1 > enemies.size():
		return
		
	var enemies_to_spawn = enemies[index_to_spawn]
	
	if enemies_to_spawn[0]:
		spawn_enemy(lane_start_1.global_position, lane_direction_1)
		
	if enemies_to_spawn[1]:
		spawn_enemy(lane_start_2.global_position, lane_direction_2)

		
	if enemies_to_spawn[2]:	
		spawn_enemy(lane_start_3.global_position, lane_direction_3)


func spawn_enemy(spawn_position: Vector3, direction: Vector3):
	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = spawn_position;
	enemy.direction_to_finish = direction
	
	add_child(enemy)
	
func _process(delta):
	for child in get_children():
		if 'direction_to_finish' in child:
			child.global_position += child.direction_to_finish * delta * velocity
