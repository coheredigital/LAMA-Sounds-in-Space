@tool
extends Node3D


@onready var beam = $ufo/beam
@onready var beam_transform = %BeamTransform
@onready var beam_transform_target = %BeamTransformTarget


@export_range(1.0,8.0,0.1) var turn_speed := 2.0

func _ready():
	if beam_transform:
		beam_transform.top_level = true
	
func _process(delta):
	var distance = beam_transform.position.distance_to(beam_transform_target.position)
	var distance_ratio = clamp(smoothstep(0.0, 1.0, distance), 0.0,1.0)
#	if distance > 0.01:
#		var follow_speed = lerp(0.1, 4.0, distance_ratio);
#		beam_transform.position = beam_transform.position.move_toward(beam_transform_target.global_transform.origin, delta * follow_speed)

	if beam:
		var look_transform = beam.global_transform.looking_at(beam_transform.global_transform.origin, Vector3( 0,0,1))
		beam.global_transform = beam.global_transform.interpolate_with(look_transform, delta * turn_speed)
	
