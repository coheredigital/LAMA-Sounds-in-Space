extends Node

signal mission_changed(value: String)
signal level_changed(value: String)
signal screen_changed(value: String)
signal player_state_changed(value: String)
signal character_state_changed(value: String)
signal door_open_changed(value: bool)
signal balloon_visibility_changed(value: bool)

@export var mission: String = "intro":
	set(value):
		mission = value
		mission_changed.emit(value)

@export var character_state: String = "intro":
	set(value):
		character_state = value
		character_state_changed.emit(value)

@export var level: String = "intro":
	set(value):
		level = value
		level_changed.emit(value)

@export var screen: String = "idle":
	set(value):
		screen = value
		screen_changed.emit(value)

@export var door_open: bool = false:
	set(value):
		door_open = value
		door_open_changed.emit(value)

@export var player_state: String = "intro":
	set(value):
		player_state = value
		player_state_changed.emit(value)
