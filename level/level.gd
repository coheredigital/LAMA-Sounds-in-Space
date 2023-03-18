@tool
extends Node

@export_enum("home","launch","stars_light","warp","landing") var state: String = "home":
	set(value):
		state = value
		if %StateTree:
			var state_machine : AnimationNodeStateMachinePlayback = %StateTree.get("parameters/playback")
			state_machine.travel(state)
