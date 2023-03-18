@tool
extends Node3D

@export var active := false : 
	set(value):
		active = value
		if %AnimationTree:
			var state_machine : AnimationNodeStateMachinePlayback = %AnimationTree.get("parameters/playback")
			state_machine.travel( 'on' if active else 'off' ) 
