extends Node

signal dialogue_visibility_changed(value: bool)
signal level_changed(value: String)
signal player_state_changed(value: String)
signal character_state_changed(value: String)
signal spaceship_motion_changed(value: float)
signal door_open_changed(value: bool)
signal seatbelt_status_changed(value: bool)
signal screen_changed(value: String)
signal steering_motion_changed(value: float)
signal fuel_level_changed(value: float)

@export var dialogue_visible: bool = false:
	set(value):
		dialogue_visible = value
		dialogue_visibility_changed.emit(value)

@export var character_state: String = "intro":
	set(value):
		character_state = value
		character_state_changed.emit(value)

@export var level: String = "intro":
	set(value):
		level = value
		level_changed.emit(value)

@export var player_state: String = "intro":
	set(value):
		player_state = value
		player_state_changed.emit(value)
		
@export_range(0.0,1.0) var spaceship_motion: float = 0.0:
	set(value):
		spaceship_motion = value
		spaceship_motion_changed.emit(value)

@export_range(0.0,1.0) var steering_motion: float = 0.0:
	set(value):
		steering_motion = value
		steering_motion_changed.emit(value)
		
@export var door_open: bool = false:
	set(value):
		door_open = value
		door_open_changed.emit(value)
		
@export var seatbelt_status: bool = false:
	set(value):
		seatbelt_status = value
		seatbelt_status_changed.emit(value)
		
@export var screen: String = "idle":
	set(value):
		screen = value
		screen_changed.emit(value)



