@tool
extends Node3D

@export_enum("idle","wipe","alert","computer","start_button","start_button_red","restart_button","success", "failure", "buckle_warning","visualizer") var screen_state: String = "intro":
	set(value):
		screen_state = value
		update_screen(value)

@export var door_open := false : 
	set(value):
		door_open = value
		set_door_open(value)

@export var seatbelts_buckled := false : 
	set(value):
		seatbelts_buckled = value
		set_seatbelts_buckled(value)

@export var siren_active := false : 
	set(value):
		siren_active = value
		if %Siren:
			%Siren.active = siren_active

@export_range(0.0,1.0) var steering_motion := 0.0 : 
	set(value):
		steering_motion = value
		set_steering_motion(value)

@export_range(1,8) var fuel_level := 1: 
	set(value):
		fuel_level = value
		set_fuel_level(value)

@onready var animation_tree := %AnimationTree
@onready var seatbelt_indicator := %seatbelt_indicator_left


func _ready():
	Sequencer.screen_changed.connect(update_screen)
	Sequencer.door_open_changed.connect(set_door_open)
	Sequencer.steering_motion_changed.connect(set_steering_motion)
	Sequencer.fuel_level_changed.connect(set_fuel_level)
	Sequencer.seatbelts_buckled_changed.connect(set_fuel_level)

func set_steering_motion(value: float) -> void:
	if animation_tree:
		animation_tree.set("parameters/steering_speed/scale", value)

func set_fuel_level(value: float) -> void:
	RenderingServer.global_shader_parameter_set("fuel_level", value)

func set_door_open(value: bool) -> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/door_state/playback")
		state_machine.travel( 'open' if value else 'close' ) 

func set_seatbelts_buckled(value: bool) -> void:
	if %seatbelt_indicator_left.get_active_material(0):
		print(2 if value else 1)
		%seatbelt_indicator_left.get_active_material(0).set_shader_parameter("frame_number", 2 if value else 1)


func update_screen(value: String)-> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/screen_state/playback")
		state_machine.travel(value)
