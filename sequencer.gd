extends Node

signal dialogue_visibility_changed(value: bool)
signal level_changed(value: String)
signal player_state_changed(value: String)
signal player_position_changed(value: String)
signal player_view_changed(value: String)
signal character_position_changed(value: float)
signal character_action_changed(value: String)
signal spaceship_motion_changed(value: float)
signal door_open_changed(value: bool)
signal seatbelts_buckled_changed(value: bool)
signal screen_changed(value: String)
signal steering_motion_changed(value: float)
signal fuel_level_changed(value: int)

var character_position: float = 0.0:
	set(value):
		character_position = value
		character_position_changed.emit(value)

var character_action: String = "idle":
	set(value):
		character_action = value
		character_action_changed.emit(value)

var level: String = "intro":
	set(value):
		level = value
		level_changed.emit(value)

var player_position: float = 0.0:
	set(value):
		player_position = clamp(value, 0.0,1.0)
		player_position_changed.emit(value)
		
var player_view: float = 0.0:
	set(value):
		player_view = clamp(value, 0.0,1.0)
		player_view_changed.emit(value)
		
var spaceship_motion: float = 0.0:
	set(value):
		spaceship_motion = clamp(value, 0.0,1.0)
		spaceship_motion_changed.emit(value)

var steering_motion: float = 0.0:
	set(value):
		steering_motion = clamp(value, 0.0,1.0)
		steering_motion_changed.emit(steering_motion)
		
var fuel_level: int = 1:
	set(value):
		fuel_level = clamp(value, 1,8)
		fuel_level_changed.emit(value) 
			
var door_open: bool = false:
	set(value):
		door_open = value
		door_open_changed.emit(value)
		
var seatbelts_buckled: bool = false:
	set(value):
		seatbelts_buckled = value
		seatbelts_buckled_changed.emit(value)
		
var screen: String = "idle":
	set(value):
		screen = value
		screen_changed.emit(value)



