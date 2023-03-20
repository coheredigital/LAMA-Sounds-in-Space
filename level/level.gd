extends Node

@export_enum("intro","launch","stars_light","warp","landing") var state: String = "intro":
	set(value):
		state = value
		update_state(value)

@onready var state_tree := %StateTree

func _ready():
	Sequencer.level_changed.connect(update_state)
	
func update_state(value: String) -> void: 
	if %StateTree:
		var state_machine : AnimationNodeStateMachinePlayback = %StateTree.get("parameters/playback")
		state_machine.travel(value)
		
