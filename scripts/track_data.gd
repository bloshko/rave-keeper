class_name TrackData
extends Resource

var initial_bpm: float
var initial_subdiv: float
var bpm_curves: Array[LinearBPMCurve]

# beat -> lane
var evil_events: Dictionary[int, int] 

# beat -> subdiv
var subdiv_changes: Dictionary[int, float]

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

	return data

func get_bpm(beat: int) -> float:
	for curve in bpm_curves:
		if beat in range(curve.beat_begin, curve.beat_end):
			var change_per_beat = (curve.bpm_end - curve.bpm_begin) / (curve.beat_end - curve.beat_begin)
			return curve.bpm_begin + change_per_beat * (beat + .5)

	var bpm = initial_bpm
	for curve in bpm_curves:
		if beat >= curve.beat_end:
			bpm = curve.bpm_end
	
	return bpm

func get_subdiv(beat: int):
	var subdiv = initial_subdiv

	var keys = subdiv_changes.keys()
	keys.sort()

	for key in keys:
		if key <= beat:
			subdiv = subdiv_changes[key]

	return subdiv
