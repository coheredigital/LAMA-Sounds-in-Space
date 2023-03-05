@tool
extends AnimationTree

@export_enum("intro","blast_off","stars_light_up","warp","landing") var mission_state: String = "intro":
	set(value):
		mission_state = value
		change_state('mission_state', value)

@export_enum("intro","approach_spaceship","enter_spaceship") var player_state: String = "intro":
	set(value):
		player_state = value
		change_state('player_state', value)

@export_enum("intro","enter_spaceship","standing","sitting") var character_state: String = "intro":
	set(value):
		character_state = value
		change_state('character_state', value)

@export_enum("idle","buckle_warning","talking_head","success","failure","restart_button","visualizer") var screen_state: String = "intro":
	set(value):
		screen_state = value
		change_state('screen_state', value)


func change_state(machine : String, state_name: String) -> void:
	var state_machine = self.get("parameters/%s/playback" % [machine])
	state_machine.travel(state_name)
