#@tool
extends Node3D


@export_enum(
	"idle",
	"playing",
	"recording",
	"alert",
	"buckle_warning",
	"battery",
	"start_button",
	"start_button_pressed",
	"start_button_red",
	"start_button_red_pressed",
	"restart_button",
	"computer",
	"sleep",
	"success",
	"failure"
) var screen_state: String = "idle":
	set(value):
		screen_state = value
		update_screen(value)

@export var door_open := false : 
	set(value):
		door_open = value
		set_door_open(value)
		
@export_enum("idle","ready","open","close") var door_state := "idle": 
	set(value):
		door_state = value
		set_door_state(value)
		
@export var seatbelts_buckled := false : 
	set(value):
		seatbelts_buckled = value
		set_seatbelts_buckled(value)

@export var siren_active := false : 
	set(value):
		siren_active = value
		if %Siren:
			%Siren.active = siren_active

@export_range(0.0,1.0,0.1) var steering_motion := 0.0 : 
	set(value):
		steering_motion = value
		set_steering_motion(value)

@export_range(0.0,1.0,0.1) var flying_motion := 0.0 : 
	set(value):
		flying_motion = value
		set_flying_motion(value)

@export_range(0.0,1.0) var light_level := 0.0 : 
	set(value):
		light_level = value
		set_light_level(value)

@export_range(0.0,1.0,0.1) var progress_bar := 0.0 : 
	set(value):
		progress_bar = value
		if progress_indicator:
			progress_indicator.progress_ratio = value


var fuel_level := 1: 
	set(value):
		fuel_level = value
		set_fuel_level(value)

@onready var animation_tree : AnimationTree = %AnimationTree
@onready var seatbelt_indicator := %seatbelt_indicator_left
@onready var seatbelt_indicator_material : ShaderMaterial = %seatbelt_indicator_left.get_active_material(0)
@onready var light := %Light 
@onready var progress_indicator := %ProgressPathFollow
@onready var computer_audio_player := %ComputerAudioPlayer


func _ready():
	Sequencer.screen_changed.connect(update_screen)
	Sequencer.played_computer_sound.connect(play_sound)
	Sequencer.door_state_changed.connect(set_door_state)
	Sequencer.steering_motion_changed.connect(set_steering_motion)
	Sequencer.flying_motion_changed.connect(set_flying_motion)
	Sequencer.stars_brightness_changed.connect(set_light_level)
	Sequencer.fuel_level_changed.connect(set_fuel_level)
	Sequencer.seatbelts_buckled_changed.connect(set_seatbelts_buckled)

func set_steering_motion(value: float, duration: float = 1.0) -> void:
	if animation_tree:
		var tween = create_tween()
		tween.parallel().tween_property(animation_tree, "parameters/steering_speed/scale", smoothstep(0.0,1.0,value), duration)
		tween.parallel().tween_property(animation_tree, "parameters/steering_blend/add_amount", smoothstep(0.0,1.0,value), duration)


func set_flying_motion(value: float, duration: float = 1.0) -> void:
	if animation_tree:
		var tween = create_tween()
		tween.parallel().tween_property(animation_tree, "parameters/flying_speed/scale", smoothstep(0.0,1.0,value), duration)
		tween.parallel().tween_property(animation_tree, "parameters/flying_blend/add_amount", smoothstep(0.0,1.0,value), duration)

func set_light_level(value: float, duration: float = 1.0) -> void:
	if not light:
		return
		
	var tween = create_tween()
	if not tween:
		return
		
	tween.tween_property(light, "light_energy", lerp(0.01,0.3,value), duration ).set_trans(Tween.TRANS_SINE)

func set_fuel_level(value: float) -> void:
	RenderingServer.global_shader_parameter_set("fuel_level", value)

func set_door_open(value: bool) -> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/door_state/playback")
		state_machine.travel( 'open' if value else 'close' ) 
		
func set_door_state(value: String) -> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/door_state/playback")
		state_machine.travel( value ) 

func set_seatbelts_buckled(value: bool) -> void:
	if seatbelt_indicator_material:
		seatbelt_indicator_material.set_shader_parameter("frame_number", 2 if value else 1)

func update_screen(value: String)-> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/screen_state/playback")
		state_machine.travel(value)


func play_sound(value: String, volume_adjustment: float = 0.0) -> void:
#	get the file or cancel operation
	var default_volume_db = -12.0
	var folder = "res://audio/effects/"
	var filename = "%s/%s.wav" % [folder,value];
	var wav_file = load(filename);
	if not wav_file:
		push_warning('Computer sound not found: %s' % [filename])
		return
#	Visualizer.channel = "Stimuli"
	computer_audio_player.volume_db = default_volume_db + volume_adjustment
	computer_audio_player.stream = wav_file
	computer_audio_player.playing = true
	EventLogger.add('stimuli','played',filename)
