extends Node

@onready var gboy = $"../GBoy"
@onready var enemy_manager = $"../EnemyManager"
@onready var music_manager = $"../MusicManager"

var kills: int = 0

func _ready() -> void:
	music_manager.beat_hit.connect(_beat_hit)
