extends Node

signal track_ready(data: TrackData)

const json_path = "res://json/level2.json"

func load_track():
	var file = FileAccess.open(json_path, FileAccess.READ)
	var content = file.get_as_text()
	
	var json = JSON.new()
	var error = json.parse(content)
	
	if error == OK:
		var dict = json.data
		if typeof(dict) == TYPE_DICTIONARY:
			var data = TrackData.from_dict(dict)
			track_ready.emit(data)
		else:
			print("Unexpected data")
