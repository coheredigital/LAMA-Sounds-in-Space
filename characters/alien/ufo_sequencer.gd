extends Node

signal position_changed(value: float, duration: float)
signal pivot_changed(value: float, duration: float)
signal tilt_changed(value: float, duration: float)
signal beam_activated(value: bool)
signal speakers_toggled(value: bool)


func move_to(progress: float, duration: float = 1.0) -> void:
	position_changed.emit(progress, duration)

func pivot(value: float = 0.0, duration: float = 1.0) -> void:
	pivot_changed.emit(value, duration)

func tilt(value: float = 0.0, duration: float = 1.0) -> void:
	tilt_changed.emit(value, duration)

func activate_beam() -> void:
	beam_activated.emit(true)

func deactivate_beam() -> void:
	beam_activated.emit(false)


func toggle_speakers(state: bool) -> void:
	speakers_toggled.emit(state)

func set_search_progress(step: float, step_max: float, duration: float = 1.0) -> void: 
	var progress = clamp(step,0.0,step_max) / step_max
#	position changes
	var position_start = 0.9
	var position_end = 0.3
	var position = lerp(position_start,position_end,progress)	
	position_changed.emit(position, duration)
#	pivot changes
	var pivot_start = 0.0
	var pivot_end = -1.0
	var pivot = lerp(pivot_start,pivot_end, position)
	pivot_changed.emit(pivot, duration)
