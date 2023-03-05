@tool
extends Node3D

@export var door_open := false : 
	set(value):
		door_open = value
		var state_machine : AnimationNodeStateMachinePlayback = %DoorState.get("parameters/playback")
		state_machine.travel( 'open' if door_open else 'close' ) 


