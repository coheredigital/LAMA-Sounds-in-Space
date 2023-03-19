@tool
extends Node3D

@export var color := Color.KHAKI :
	set(value):
		color = value
		if star_light:
			star_light.light_color = color

@export_range(0.0, 1.0) var rotation_speed := 0.0 : 
	set(value):
		rotation_speed = value
		if animation_player:
			animation_player.speed_scale = rotation_speed

@onready var star_light := %StarLight
@onready var Particles := %Particles
@onready var animation_player := %IdleAnimationPlayer
