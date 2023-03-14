@tool
extends Node3D

const LIGHT_RANGE := 0.0

#@onready var material : ShaderMaterial = %StarMesh.get_active_material(0)

@export var color := Color.KHAKI :
	set(value):
		color = value
		if %StarLight:
			%StarLight.light_color = color

@export_range(0.0, 1.0) var rotation_speed := 0.0 : 
	set(value):
		rotation_speed = value
		if %IdleAnimationPlayer:
			%IdleAnimationPlayer.speed_scale = rotation_speed

func _ready():
	%IdleAnimationPlayer.play("idle")
