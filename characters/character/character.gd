@tool
extends Node3D


@export_enum("intro","enter_spaceship","standing","sitting") var state: String = "intro":
	set(value):
		state = value
		if state_tree:
			var position_state : AnimationNodeStateMachinePlayback = state_tree.get("parameters/position/playback")
			position_state.travel(state)

@export_enum("idle","talking") var action: String = "idle":
	set(value):
		action = value
		if state_tree:
			var action_state : AnimationNodeStateMachinePlayback = state_tree.get("parameters/action/playback")
			action_state.travel(action)

@onready var state_tree := %StateTree
