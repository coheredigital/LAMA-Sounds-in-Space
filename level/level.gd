@tool
extends WorldEnvironment

const SKY_SIZE = 64.0

@export_enum("home","launch","stars_light","warp") var state: String = "intro":
	set(value):
		state = value
		if %StateTree:
			var state_machine : AnimationNodeStateMachinePlayback = %StateTree.get("parameters/playback")
			state_machine.travel(state)
