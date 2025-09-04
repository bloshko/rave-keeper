extends Node

var save: RaveFile

func _ready() -> void:
	save = RaveFile.try_load()
	tree_exiting.connect(func(): save.save())
