extends Node


signal level_changed(value: String)
signal stars_brightness_changed(value: float)
signal star_moved(star_number: int, progress: float)

signal character_position_changed(value: float, duration: float)
signal character_action_changed(value: String)

signal spaceship_motion_changed(value: float)
signal door_open_changed(value: bool)
signal steering_motion_changed(value: float)
signal flying_motion_changed(value: float)

signal seatbelts_buckled_changed(value: bool)
signal screen_changed(value: String)
signal fuel_level_changed(value: int)

signal overlay_state_changed(state:String)

var level: String = "intro":
	set(value):
		level = value
		level_changed.emit(value)

var character_position: float = 0.0:
	set(value):
		character_position = value
		character_position_changed.emit(value, 0.0)

var character_action: String = "idle":
	set(value):
		character_action = value
		character_action_changed.emit(value)

var stars_brightness: float = 0.0:
	set(value):
		stars_brightness = clamp(value, 0.0,1.0)
		stars_brightness_changed.emit(stars_brightness)

var player_position: float = 0.0
var player_view: float = 0.0
		
var spaceship_motion: float = 0.0:
	set(value):
		spaceship_motion = clamp(value, 0.0,1.0)
		spaceship_motion_changed.emit(value)

var steering_motion: float = 0.0:
	set(value):
		steering_motion = clamp(value, 0.0,1.0)
		steering_motion_changed.emit(steering_motion)
		
var flying_motion: float = 0.0:
	set(value):
		flying_motion = clamp(value, 0.0,1.0)
		flying_motion_changed.emit(flying_motion)
		
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

func overlay_state(state : String) -> void:
	overlay_state_changed.emit(state)

func move_character(progress: float, duration: float = 1.0) -> void:
	character_position_changed.emit(progress, duration)

func character_view_angle(angle: Vector2, duration: float = 1.0) -> void:
	character_position_changed.emit(angle, duration)

func move_star(star_number: int, progress: float, duration: float = 1.0) -> void:
	star_moved.emit(star_number, progress, duration)

func play_audio(file: String) -> void:
	print('Playing audio file: %s' % file)

