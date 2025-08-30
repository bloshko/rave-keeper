extends Node

signal music_events_parsed(music_events: Dictionary)

const jsonFile = "res://json/test_music.json"

func _ready():
	var file = FileAccess.open(jsonFile, FileAccess.READ)
	var content = file.get_as_text()
	
	var json = JSON.new()
	var error = json.parse(content)
	
	if error == OK:
		var data = json.data
		if typeof(data) == TYPE_DICTIONARY:
			music_events_parsed.emit(data)
		else:	
			print("Unexpected data")
