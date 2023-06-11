extends Node

signal position_changed(value: float, duration: float)
signal pivot_changed(value: float, duration: float)
signal tilt_changed(value: float, duration: float)
signal beam_activated(value: bool)


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
