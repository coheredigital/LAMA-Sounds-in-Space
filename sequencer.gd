extends Node

signal mission_changed(name: String)
signal level_changed(name: String)
signal screen_changed(name: String)

@export var mission: String = "home":
	set(value):
		level = value
		mission_changed.emit(value)
		print("mission: %s" % value)

@export var level: String = "home":
	set(value):
		level = value
		level_changed.emit(value)
		print("level: %s" % value)

@export var screen: String = "home":
	set(value):
		level = value
		screen_changed.emit(value)
		print("level: %s" % value)
