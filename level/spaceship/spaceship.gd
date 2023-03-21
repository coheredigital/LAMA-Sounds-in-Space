@tool
extends Node3D

@export_enum("idle","wipe","alert","computer","start_button","restart_button","success", "failure", "buckle_warning") var screen_state: String = "intro":
	set(value):
		screen_state = value
		update_screen(value)

@export var door_open := false : 
	set(value):
		door_open = value
		set_door_open(value)

@export var siren_active := false : 
	set(value):
		siren_active = value
		if %Siren:
			%Siren.active = siren_active

@export_range(0.0,1.0) var steering_motion := 0.0 : 
	set(value):
		steering_motion = value
		set_steering_motion(value)


@export_range(0.0,1.0) var fuel_level := 0.0 : 
	set(value):
		fuel_level = value
		RenderingServer.global_shader_parameter_set("fuel_level", value)
		
@onready var animation_tree := %AnimationTree

func _ready():
	Sequencer.screen_changed.connect(update_screen)
	Sequencer.door_open_changed.connect(set_door_open)
	Sequencer.steering_motion_changed.connect(set_steering_motion)

func set_steering_motion(value: float) -> void:
	if animation_tree:
		animation_tree.set("parameters/steering_speed/scale", value)

func set_door_open(value: bool) -> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/door_state/playback")
		state_machine.travel( 'open' if value else 'close' ) 

func update_screen(value: String)-> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/screen_state/playback")
		state_machine.travel(value)
