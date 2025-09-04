class_name RaveFile
extends Resource

@export var normal_score: int
@export var hard_score: int

const SAVE_PATH = "user://save.res"

static func try_load() -> RaveFile:
	if ResourceLoader.exists(SAVE_PATH):
		return ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	else: 
		var data = RaveFile.new()
		data.save()
		return data

func save():
	ResourceSaver.save(self, SAVE_PATH)
