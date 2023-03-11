@tool
extends Node3D

@export_range(-16.0, 16.0) var depth := 0.0 : 
	set(value):
		depth = value
		%Positions.scale.z = depth


@export_range(-16.0, 16.0) var width := 2.0 : 
	set(value):
		width = value
		%Positions.scale.x = width

@export_range(-16.0, 16.0) var height := 2.0 : 
	set(value):
		height = value
		%Positions.scale.y = height
