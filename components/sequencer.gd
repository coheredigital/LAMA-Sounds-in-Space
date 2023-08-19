extends Node


signal level_changed(value: String)
signal stars_brightness_changed(value: float)
signal star_moved(star_number: int, progress: float)
signal altitude_changed(value: float, duration: float)
signal visible_planet_changed(value: String)
signal planet_scale_changed(value: float, duration: float)
signal planet_distance_changed(value: float, duration: float)
signal planet_height_changed(value: float, duration: float)

signal character_position_changed(value: float, duration: float)
signal character_action_changed(value: String)

signal spaceship_motion_changed(value: float)
signal door_state_changed(value: String)
signal steering_motion_changed(value: float)
signal flying_motion_changed(value: float)

signal seatbelts_buckled_changed(value: bool)
signal screen_changed(value: String)
signal fuel_level_changed(value: int)

signal overlay_state_changed(state:String)

signal stimuli_set_changed(stimuli_set:Array)

var character_position: float = 0.0:
	set(value):
		character_position = value
		character_position_changed.emit(value, 0.0)

var character_action: String = "idle":
	set(value):
		character_action = value
		character_action_changed.emit(value)



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
		
var door_state: String = "idle":
	set(value):
		door_state = value
		door_state_changed.emit(value)
		
var seatbelts_buckled: bool = false:
	set(value):
		seatbelts_buckled = value
		seatbelts_buckled_changed.emit(value)
		
var screen: String = "idle":
	set(value):
		screen = value
		screen_changed.emit(value)

var stimuli_set: Array = []:
	set(value):
		stimuli_set = value
		stimuli_set.shuffle()
		print("Stimuli set: %s" % [stimuli_set])
		stimuli_set_changed.emit(value)

var next_stimuli = '':
	set(value):
		next_stimuli = value
		print("Next stimuli: %s" % [next_stimuli])

func get_next_stimuli() -> String:
	next_stimuli = stimuli_set.pop_front()
	return next_stimuli if next_stimuli else ''

func set_stars_brightness(step: float, max: float) -> void:
	var brightness = step / max
	brightness = float(brightness)
	brightness = clamp(brightness,0.0,1.0)
	stars_brightness_changed.emit(brightness)



func overlay_state(state : String) -> void:
	overlay_state_changed.emit(state)

func move_character(progress: float, duration: float = 1.0) -> void:
	character_position_changed.emit(progress, duration)

func character_view_angle(angle: Vector2, duration: float = 1.0) -> void:
	character_position_changed.emit(angle, duration)

func move_star(star_number: float, progress: float, duration: float = 1.0) -> void:
#	round star down to allow fractions used in sequence
	star_number = floor(star_number)
	if star_number != 0:
		star_moved.emit(star_number, progress, duration)

func update_altitude(height: float, duration: float = 1.0) -> void:
	altitude_changed.emit(height,duration)

func update_planet_scale(scale: float, duration: float = 1.0) -> void:
	planet_scale_changed.emit(scale,duration)

func set_visible_planet(value: String):
	visible_planet_changed.emit(value)

func update_planet_distance(distance: float, duration: float = 1.0) -> void:
	planet_distance_changed.emit(distance,duration)

func update_planet_progress(step: float, max: float, duration: float = 1.0) -> void:
	var progress = step / max
	var distance = lerp(0.9,0.15,progress)
	planet_distance_changed.emit(distance,duration)
	var height = lerp(0.75,0.65,progress)
	planet_height_changed.emit(height,duration)



func update_planet_height(height: float, duration: float = 1.0) -> void:
	planet_height_changed.emit(height,duration)

func print_message(text: String) -> void:
	print('Message: %s' % text)


