class_name TrackData
extends Resource

var initial_bpm: float
var initial_subdiv: float
var bpm_curves: Array[LinearBPMCurve]
var evil_events: Dictionary[int, int] 
var subdiv_changes: Dictionary[int, float]

var beat_timestamps_ms: Array[float] = []

class LinearBPMCurve:
	var beat_begin: int
	var beat_end: int

	var bpm_begin: float
	var bpm_end: float

static func from_dict(dict: Dictionary) -> TrackData:
	var data = TrackData.new()
	data.initial_subdiv = dict["initial_subdiv"]
	data.initial_bpm = dict["initial_bpm"]
	
	var bpm_curve_temp: LinearBPMCurve
	for event in dict["events"]:
		match event["type"]:
			"begin_bpm_curve":
				bpm_curve_temp = LinearBPMCurve.new()
				bpm_curve_temp.beat_begin = event["beat"]
				bpm_curve_temp.bpm_begin = event["bpm"]
			"end_bpm_curve":
				bpm_curve_temp.beat_end = event["beat"]
				bpm_curve_temp.bpm_end = event["bpm"]
				data.bpm_curves.append(bpm_curve_temp)
			"set_subdiv":
				data.subdiv_changes.set(int(event["beat"]), event["value"])
			"evil":
				data.evil_events.set(int(event["beat"]), int(event["lane"]))
			
	data.beat_timestamps_ms.append_array(generate_beat_timestamps(data))
	return data

func get_bpm(beat: int) -> float:
	for curve in bpm_curves:
		if beat in range(curve.beat_begin, curve.beat_end):
			var change_per_beat = float(curve.bpm_end - curve.bpm_begin) / float(curve.beat_end - curve.beat_begin)
			return curve.bpm_begin + change_per_beat * (beat - curve.beat_begin + .5)

	var bpm = initial_bpm
	for curve in bpm_curves:
		if beat >= curve.beat_end:
			bpm = curve.bpm_end
	
	return bpm
	
static func generate_beat_timestamps(track_data: TrackData) -> Array:
	var keys = track_data.evil_events.keys()
	var max_beats_num = keys[len(keys) - 1]
	
	var accumulated_time_s = 0
	var beat_timestamps_ms = [accumulated_time_s]
	
	var last_subdiv = track_data.initial_subdiv
	var last_bpm = track_data.initial_bpm

	var last_seconds_per_beat = 1 / (last_subdiv * (last_bpm / 60))
	
	for i in range(max_beats_num):
		var subdiv_change = track_data.subdiv_changes.get(i)
		last_bpm = track_data.get_bpm(i)
		if subdiv_change != null:
			last_subdiv = subdiv_change
		
		last_seconds_per_beat = 1 / (last_subdiv * (last_bpm / 60)) 

		accumulated_time_s += last_seconds_per_beat
		
		beat_timestamps_ms.append(accumulated_time_s * 1000)
		
	return beat_timestamps_ms

func get_subdiv(beat: int):
	var subdiv = initial_subdiv

	var keys = subdiv_changes.keys()
	keys.sort()

	for key in keys:
		if key <= beat:
			subdiv = subdiv_changes[key]

	return subdiv
