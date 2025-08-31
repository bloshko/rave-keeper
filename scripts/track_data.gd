class_name TrackData
extends Resource

# beat -> lane
var evil_events: Dictionary[int, int] 

# beat -> bpm
var bpm_curve_points: Dictionary[int, float] 

# beat -> subdiv
var subdiv_changes: Dictionary[int, float]

static func from_dict(dict: Dictionary) -> TrackData:
	var data = TrackData.new()
	return data

func get_bpm(beat: int) -> float:
	return 0
