@tool
extends Node

@export_range(0,1) var strong_magnitude = 0.0:
	set(value):
		strong_magnitude = value
		Input.start_joy_vibration(0,weak_magnitude,strong_magnitude,2.0)


@export_range(0,1) var weak_magnitude = 0.0:
	set(value):
		weak_magnitude = value
		Input.start_joy_vibration(0,weak_magnitude,strong_magnitude,2.0)


