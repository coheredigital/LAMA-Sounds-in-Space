@tool
class_name FollowCamera
extends Node


@export_enum("intro","approach_spaceship","boarding","enter_spaceship","sitting") var state: String = "intro":
	set(value):
		state = value
		if position_state_tree:
			var state_machine = position_state_tree.get("parameters/playback")
			state_machine.travel(state)

@export_range (1.0, 8.0) var follow_speed = 3.0
@export_range (1.0, 8.0) var turn_speed = 4.0
@export_range (0.0, 10.0) var distance_buffer = 1.0
@export_range (1.0, 10.0) var distance_boost = 2.0

@onready var position_state_tree = %PositionStateTree
@onready var target : Marker3D = $PositionTarget
@onready var look_target : Marker3D = $LookTarget
@onready var camera := $Camera3D


func _process(delta):

	if not target or not look_target:
		return
	var distance = camera.position.distance_to(target.global_transform.origin)
	var follow_distance_speed = lerp(0.1, pow(follow_speed,distance_boost), clamp(smoothstep(0.0, distance_buffer, distance), 0.0,1.0));

#	position = lerp(position, target.global_transform.origin, delta * follow_distance_speed)
	camera.position = camera.position.move_toward(target.global_transform.origin, delta * follow_distance_speed)
#	look_at_from_position(target.global_transform.origin, look_target.global_transform.origin, Vector3.UP)
	var look_transform = camera.global_transform.looking_at(look_target.global_transform.origin, Vector3.UP)

	camera.global_transform = camera.global_transform.interpolate_with(look_transform, delta * turn_speed)


