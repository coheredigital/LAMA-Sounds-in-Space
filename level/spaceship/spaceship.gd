@tool
extends Node3D


@export_enum("idle","wipe","talking_head","start_button","restart_button","success", "failure", "buckle_warning") var screen_state: String = "intro":
	set(value):
		screen_state = value
		if %AnimationTree:
			var state_machine : AnimationNodeStateMachinePlayback = %AnimationTree.get("parameters/screen_state/playback")
			state_machine.travel(screen_state)

@export var door_open := false : 
	set(value):
		door_open = value
		if %AnimationTree:
			var state_machine : AnimationNodeStateMachinePlayback = %AnimationTree.get("parameters/door_state/playback")
			state_machine.travel( 'open' if door_open else 'close' ) 

@export var siren_active := false : 
	set(value):
		siren_active = value
		if %Siren:
			%Siren.active = siren_active

@export_range(0.0,1.0) var steering_motion := 0.0 : 
	set(value):
		steering_motion = value
		if %AnimationTree:
			%AnimationTree.set("parameters/steering_speed/scale", steering_motion)

@export_range(0.0,1.0) var fuel_level := 0.0 : 
	set(value):
		fuel_level = value
		
