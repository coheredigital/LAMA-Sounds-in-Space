@tool
extends Node

@onready var character_path := %CharacterPath
@onready var player_path := %PlayerPath
@onready var alien := %Alien
@onready var alien_path := %AlienPath
@onready var ufo_path := %UfoPath
@onready var lama_path := %LamaPath
@onready var lama_rescued := %LamaRescued
@onready var lama_lost := %LamaLost
@onready var spaceship := %Spaceship
@onready var station := %Station
@onready var planet_stardust := %PlanetStardust
@onready var environment := %Environment
@onready var spaceship_audio = %SpaceshipAudio


@export_range(0.0,1.0,0.00001) var journey_progress : float = 0.0 : 
	set(value):
		journey_progress = value
		
		if spaceship:
			spaceship.progress_bar = journey_progress
		if environment:
			var altitude = journey_altitude_curve.sample_baked(journey_progress)
			var stars_progress = journey_stars_progress_curve.sample_baked(journey_progress)
			environment.planet_distance = 1.0 - journey_progress
			environment.altitude = altitude
			environment.stars_progress = stars_progress
		if not planet_stardust or not station:
			return
		if journey_progress > 0.5 :
			planet_stardust.visible = true
			station.visible = false
		else:
			station.visible = true
			planet_stardust.visible = false

@export var journey_altitude_curve : Curve = preload("res://level/environment/curves/journey_altitude_curve.tres")
@export var journey_stars_progress_curve : Curve = preload("res://level/environment/curves/journey_stars_progress_curve.tres")

func _ready():
#	Global Sequencer
	Sequencer.journey_progress_changed.connect(set_journey_progress)
	Sequencer.spaceship_audio_played.connect(play_spaceship_audio)
	
#	TODO: Simplify pattern
#	Player
	Player.position_changed.connect(set_player_position)
	Player.pivot_changed.connect(set_player_pivot)
	Player.tilt_changed.connect(set_player_tilt)
	
#	Character (Sam)
	Character.position_changed.connect(set_character_postion)
	Character.pivot_changed.connect(set_character_pivot)
	Character.tilt_changed.connect(set_character_tilt)
	
#	Alien
	Alien.position_changed.connect(set_alien_postion)
	Alien.pivot_changed.connect(set_alien_pivot)
	Alien.tilt_changed.connect(set_alien_tilt)
	
#	Lama
	Lama.position_changed.connect(set_lama_postion)
	Lama.pivot_changed.connect(set_lama_pivot)
	Lama.tilt_changed.connect(set_lama_tilt)
	Lama.rescued_state_changed.connect(set_lama_visibility)

#	UFO
	Ufo.position_changed.connect(set_ufo_postion)
	Ufo.pivot_changed.connect(set_ufo_pivot)
	Ufo.tilt_changed.connect(set_ufo_tilt)	

		
# Mission
func set_journey_progress(value: float, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "journey_progress", value, duration).set_trans(Tween.TRANS_SINE)

	

# Generic Path update functions
func set_path_position(path: Path3D, position: float, duration: float = 1.0) -> void: 
	if path:
		var tween = create_tween()
		tween.tween_property(path, "progress_ratio", position, duration).set_trans(Tween.TRANS_SINE)

func set_path_pivot(path: Path3D, pivot: float, duration: float = 1.0) -> void: 
	if path:
		var tween = create_tween()
		tween.tween_property(path, "pivot", pivot, duration).set_trans(Tween.TRANS_SINE)
		
func set_path_tilt(path: Path3D, tilt: float, duration: float = 1.0) -> void: 
	if path:
		var tween = create_tween()
		tween.tween_property(path, "tilt", tilt, duration).set_trans(Tween.TRANS_SINE)
		
# Player 
func set_player_position(position: float, duration: float = 1.0) -> void: 
	set_path_position(player_path,position,duration)

func set_player_pivot(pivot: float, duration: float = 1.0) -> void: 
	set_path_pivot(player_path,pivot,duration)

func set_player_tilt(tilt: float, duration: float = 1.0) -> void: 
	set_path_tilt(player_path,tilt,duration)

#	Character (Sam)
func set_character_postion(position: float, duration: float = 1.0) -> void: 
	set_path_position(character_path,position,duration)

func set_character_pivot(pivot: float, duration: float = 1.0) -> void: 
	set_path_pivot(character_path,pivot,duration)

func set_character_tilt(tilt: float, duration: float = 1.0) -> void: 
	set_path_tilt(character_path,tilt,duration)


#	Alien
func set_alien_postion(position: float, duration: float = 1.0) -> void: 
	set_path_position(alien_path,position,duration)

func set_alien_pivot(pivot: float, duration: float = 1.0) -> void: 
	set_path_pivot(alien_path,pivot,duration)

func set_alien_tilt(tilt: float, duration: float = 1.0) -> void: 
	set_path_tilt(alien_path,tilt,duration)


#	Lama
func set_lama_postion(position: float, duration: float = 1.0) -> void: 
	set_path_position(lama_path,position,duration)

func set_lama_pivot(pivot: float, duration: float = 1.0) -> void: 
	set_path_pivot(lama_path,pivot,duration)

func set_lama_tilt(tilt: float, duration: float = 1.0) -> void: 
	set_path_tilt(lama_path,tilt,duration)
	
func set_lama_visibility(value: bool) -> void: 
	if not lama_rescued or not lama_lost:
		return
	if value:
		lama_rescued.visible = true
		lama_lost.visible = false
	else:
		lama_rescued.visible = false
		lama_lost.visible = true

# Spaceship
func play_spaceship_audio(value: String, volume_adjustment : float = 0.0) -> void:
	var default_volume_db = -27.0
#	get the file or cancel operation
	var folder = "res://audio/"
	var filename = "%s/%s.wav" % [folder,value]
	
	var wav_file = load(filename)
	if not wav_file:
		push_warning('Sound not found: %s' % [filename])
		return
	spaceship_audio.volume_db = default_volume_db + volume_adjustment
	spaceship_audio.stream = wav_file
	spaceship_audio.playing = true
	EventLogger.add('stimuli','played',filename)
	
#	UFO
func set_ufo_postion(position: float, duration: float = 1.0) -> void: 
	set_path_position(ufo_path,position,duration)

func set_ufo_pivot(pivot: float, duration: float = 1.0) -> void: 
	set_path_pivot(ufo_path,pivot,duration)

func set_ufo_tilt(tilt: float, duration: float = 1.0) -> void: 
	set_path_tilt(ufo_path,tilt,duration)
	
