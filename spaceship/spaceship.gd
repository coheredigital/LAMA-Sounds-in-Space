@tool
extends Node3D

@export var door_open := false : 
	set(value):
		door_open = value
		var state_machine : AnimationNodeStateMachinePlayback = %DoorState.get("parameters/playback")
		state_machine.travel( 'open' if door_open else 'close' ) 


@export_range(0.0,1.0) var steering_motion := 0.0 : 
	set(value):
		steering_motion = value
		%SteeringMotion.set("parameters/TimeScale/scale", steering_motion)
