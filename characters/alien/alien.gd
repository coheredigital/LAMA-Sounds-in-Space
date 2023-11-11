#@tool
extends Node3D

@export_enum("idle","wave") var action : String = "idle":
	set(value):
		action = value
		set_action(action)
		
@onready var action_tree = %ActionTree


func _ready():
	Alien.action_changed.connect(set_action)
	
func set_action(value: String) -> void:
	if action_tree:
		var state_machine : AnimationNodeStateMachinePlayback = action_tree.get("parameters/actions/playback")
		state_machine.travel(value) 

