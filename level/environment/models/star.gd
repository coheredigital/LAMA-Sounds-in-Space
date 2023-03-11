@tool
extends Node3D

const LIGHT_RANGE := 0.0

#@onready var material : ShaderMaterial = %StarMesh.get_active_material(0)

@export var color := Color.KHAKI :
	set(value):
		color = value
		if %StarLight:
			%StarLight.light_color = color

@export_range(0.0, 8.0) var size := 0.0 : 
	set(value):
		size = value
		self.scale = Vector3(size,size,size)

@export_range(0.0, 8.0) var brightness := 0.0 : 
	set(value):
		brightness = value
		if %StarLight:
			%StarLight.light_energy = brightness

@export_range(0.0, 1.0) var rotation_speed := 0.0 : 
	set(value):
		rotation_speed = value
		if %IdleAnimationPlayer:
			%IdleAnimationPlayer.speed_scale = rotation_speed

func _ready():
	%IdleAnimationPlayer.play("idle")
