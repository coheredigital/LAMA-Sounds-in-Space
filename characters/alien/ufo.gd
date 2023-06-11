@tool
extends Node3D


@onready var beam = $ufo/beam
@onready var beam_transform = %BeamTransform
@onready var beam_transform_target = %BeamTransformTarget
@export_range(1.0,8.0,0.1) var turn_speed := 2.0
@export_range(0.0,1.0,0.1) var beam_length := 0.0:
	set(value):
		beam_length = value


	
func _process(delta):

	if beam:
		var look_transform : Transform3D = beam.global_transform
		look_transform = look_transform.looking_at(beam_transform_target.global_transform.origin, Vector3( 0,0,1))
#		look_transform = look_transform.scaled(Vector3(1.0,beam_length,1.0))
		beam.global_transform = beam.global_transform.interpolate_with(look_transform, delta * turn_speed)
	
