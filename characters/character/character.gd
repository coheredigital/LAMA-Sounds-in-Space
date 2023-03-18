@tool
extends Node3D


@export_enum("intro","enter_spaceship","standing","sitting") var state: String = "intro":
	set(value):
		state = value
		if %StateTree:
			var position_state : AnimationNodeStateMachinePlayback = %StateTree.get("parameters/position/playback")
			position_state.travel(state)

@export_enum("idle","talking") var action: String = "idle":
	set(value):
		action = value
		if %StateTree:
			var action_state : AnimationNodeStateMachinePlayback = %StateTree.get("parameters/action/playback")
			action_state.travel(action)
