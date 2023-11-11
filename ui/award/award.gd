#@tool
extends Node3D

@onready var animation_tree := $AnimationTree

@export var active := false:
	set(value):
		active = value
		toggle_award(value)

func _ready() -> void:
	Sequencer.award_toggled.connect(toggle_award)
	toggle_award(active)

func toggle_award(value: bool) -> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/state/playback")
		state_machine.travel( 'show' if value else 'hide' ) 
		var sound_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/audio/playback")
		if value:
			sound_machine.travel( 'chime' ) 
