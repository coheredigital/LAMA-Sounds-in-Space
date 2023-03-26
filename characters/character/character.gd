@tool
extends Node3D

@export_enum("idle","talking") var action: String = "idle":
	set(value):
		action = value
		if state_tree:
			var action_state : AnimationNodeStateMachinePlayback = state_tree.get("parameters/action/playback")
			action_state.travel(action)

@onready var state_tree := %StateTree

func _ready():
	Sequencer.character_action_changed.connect(update_action)

func update_state(value: String) -> void:
	if state_tree:
		var state_machine = state_tree.get("parameters/position/playback")
		state_machine.travel(value)

func update_action(value: String) -> void:
	if state_tree:
		var state_machine = state_tree.get("parameters/action/playback")
		state_machine.travel(value)
