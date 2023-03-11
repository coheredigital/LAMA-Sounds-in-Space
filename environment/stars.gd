@tool
extends Node3D

@export_range(-8.0, 8.0) var depth := 0.0 : 
	set(value):
		depth = value
		%Positions.scale.z = depth


@export_range(-8.0, 8.0) var width := 0.0 : 
	set(value):
		width = value
		%Positions.scale.x = width

@export_range(-8.0, 8.0) var height := 0.0 : 
	set(value):
		height = value
		%Positions.scale.y = height
