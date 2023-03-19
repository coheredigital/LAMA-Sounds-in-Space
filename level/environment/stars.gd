@tool
extends Node3D

@export_range(-16.0, 16.0) var depth := 0.0 : 
	set(value):
		depth = value
		if positions:
			positions.scale.z = depth


@export_range(-16.0, 16.0) var width := 2.0 : 
	set(value):
		width = value
		if positions:
			positions.scale.x = width

@export_range(-16.0, 16.0) var height := 2.0 : 
	set(value):
		height = value
		if positions:
			positions.scale.y = height

@onready var positions := %Positions

