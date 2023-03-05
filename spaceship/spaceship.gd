extends Node3D

@export var door_open := false : 
	set(value):
		print('open')
		door_open = value

