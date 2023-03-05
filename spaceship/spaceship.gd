extends Node3D

@export var door_open := false : set = set_door_open


func set_door_open(value):
	print(value)
	door_open = value
