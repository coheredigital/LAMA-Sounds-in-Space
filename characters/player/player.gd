@tool
class_name PlayerCamera
extends Node


@export_range (1.0, 8.0) var follow_speed = 3.0
@export_range (1.0, 8.0) var turn_speed = 4.0
@export_range (0.0, 10.0) var distance_buffer = 1.0
@export_range (1.0, 10.0) var distance_boost = 2.0
@export_range (0.0, 1.0) var position_progress = 0.5 :
	set(value):
		position_progress = value
		update_postion(value)
		
@export_range (0.0, 1.0) var view_progress = 0.5 :
	set(value):
		view_progress = value
		update_view(value)

@onready var camera := $Camera3D
@onready var position_target : PathFollow3D = %PositionTarget
@onready var view_target : PathFollow3D = %ViewTarget


func update_postion(value: float) -> void:
	if position_target:
		position_target.progress_ratio = value


func update_view(value: float) -> void:
	if view_target:
		view_target.progress_ratio = value


func _ready():
	Sequencer.player_position_changed.connect(update_postion)
	Sequencer.player_view_changed.connect(update_view)


func _process(delta):
	if not %PositionTarget or not %ViewTarget:
		return
	var distance = camera.position.distance_to(%PositionTarget.global_transform.origin)
	var follow_distance_speed = lerp(0.1, pow(follow_speed,distance_boost), clamp(smoothstep(0.0, distance_buffer, distance), 0.0,1.0));
	camera.position = camera.position.move_toward(%PositionTarget.global_transform.origin, delta * follow_distance_speed)
	var look_transform = camera.global_transform.looking_at(%ViewTarget.global_transform.origin, Vector3.UP)
	camera.global_transform = camera.global_transform.interpolate_with(look_transform, delta * turn_speed)

