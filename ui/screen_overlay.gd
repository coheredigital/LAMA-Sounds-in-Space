#@tool
extends ColorRect



@onready var overlay_material := load("res://ui/screen_overlay_material.tres")


@export_enum("hidden","logo","loading") var state : String = "hidden":
	set(value):
		state = value
		if %AnimationTree:
			var state_machine : AnimationNodeStateMachinePlayback = %AnimationTree.get("parameters/state/playback")
			state_machine.travel( value ) 


func _ready():
	Sequencer.overlay_state_changed.connect(set_state)
	
func set_state(value:String) -> void:
	self.state = value
	
