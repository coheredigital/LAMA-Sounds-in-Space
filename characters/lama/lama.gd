extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Lama.action_changed.connect(change_action)
	

func change_action(action:String) -> void:
	if %AnimationTree:
		var state_machine : AnimationNodeStateMachinePlayback = %AnimationTree.get("parameters/action/playback")
		state_machine.travel(action)
