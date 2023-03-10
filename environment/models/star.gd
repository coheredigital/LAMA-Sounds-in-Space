@tool
extends Node3D

@onready var material : ShaderMaterial = %StarMesh.get_active_material(0)

@export var color := Color.KHAKI :
	set(value):
		color = value
		

		if %StarLight:
			%StarLight.light_color = color


@export_range(0.0, 8.0) var brightness := 0.0 : 
	set(value):
		brightness = value
		if %StarLight:
			%StarLight.light_energy = brightness

