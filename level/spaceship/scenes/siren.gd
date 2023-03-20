@tool
extends Node3D

@export var active := false : 
	set(value):
		active = value
		if animation_tree:
			var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
			state_machine.travel( 'on' if active else 'off' ) 

@onready var animation_tree := %AnimationTree
