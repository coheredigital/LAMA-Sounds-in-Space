extends Node

signal position_changed(value: float, duration: float)
signal action_changed(value: String)
signal view_angle_changed(value: Vector2, duration: float)
signal rotation_changed(value: float, duration: float)

var position: float = 0.0:
	set(value):
		position = value
		position_changed.emit(value, 0.0)

var view_angle: Vector2 = Vector2(0.0,0.0):
	set(value):
		view_angle = value
		view_angle_changed.emit(value, 0.0)

var action: String = "idle":
	set(value):
		action = value
		action_changed.emit(value)



func move_to(progress: float, duration: float = 1.0) -> void:
	position_changed.emit(progress, duration)

func rotate(rotation: float = 0.0, duration: float = 1.0) -> void:
	rotation_changed.emit(rotation, duration)

func look_at(angle_x: float = 0.0, angle_y: float = 0.0, duration: float = 1.0) -> void:
	view_angle_changed.emit(Vector2(angle_x,angle_y), duration)
