@tool
extends Node

@export_enum("home","launch","stars_light","warp","landing") var state: String = "home":
	set(value):
		set_state(value)

@onready var StateTree := %StateTree

func _ready():
	Sequencer.level_changed.connect(_on_Sequencer_set_state)
	
func set_state(value: String) -> void: 
	state = value
	if StateTree:
		var state_machine : AnimationNodeStateMachinePlayback = StateTree.get("parameters/playback")
		state_machine.travel(state)
		
		
func _on_Sequencer_set_state() -> void: 
	print("Sequencer level: %s" % Sequencer.level )

