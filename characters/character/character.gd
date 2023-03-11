@tool
extends Node3D


@export_enum("intro","enter_spaceship","standing","sitting") var state: String = "intro":
	set(value):
		state = value
		if %StateTree:
			var position_state : AnimationNodeStateMachinePlayback = %StateTree.get("parameters/playback")
			position_state.travel(state)

@export_enum("idle","talking") var action: String = "idle":
	set(value):
		action = value
		if %ActionTree:
			var action_state : AnimationNodeStateMachinePlayback = %ActionTree.get("parameters/playback")
			action_state.travel(action)
