@tool
class_name PlayerCamera
extends Node


@export_range (1.0, 8.0, 0.1) var follow_speed = 3.0
@export_range (1.0, 8.0, 0.1) var turn_speed := 4.0
@export_range (1.0, 10.0, 0.1) var max_distance = 2.0
@export_range (0.0, 1.0, 0.01) var position_progress := 0.0 :
	set(value):
		position_progress = value
		update_postion(value)
		
@export_range (0.0, 1.0, 0.01) var view_progress := 0.25:
	set(value):
		view_progress = value
		update_view(value)

@onready var camera := $Camera3D
@onready var position_target : PathFollow3D = %PositionTarget
@onready var view_target : PathFollow3D = %ViewTarget


func update_postion(value: float, duration: float = 2.0) -> void:
	if position_target:
		var tween = create_tween()
		tween.tween_property(position_target, "progress_ratio", value, duration).set_trans(Tween.TRANS_SINE)


func update_view(value: float, duration: float = 2.0) -> void:
	if view_target:
		var tween = create_tween()
		tween.tween_property(view_target, "progress_ratio", value, duration).set_trans(Tween.TRANS_SINE)


func _ready():
#	reset view and position
	position_progress = 0.0
	view_progress = 0.0
	Sequencer.player_position_changed.connect(update_postion)
	Sequencer.player_view_changed.connect(update_view)


#func _process(delta):
#	if not %PositionTarget or not %ViewTarget:
#		return
#	var distance = camera.position.distance_to(%PositionTarget.global_transform.origin)
#	var follow_distance_speed = lerp(0.1, follow_speed, clamp(smoothstep(0.0, max_distance, distance), 0.0,1.0));
#	camera.position = camera.position.move_toward(%PositionTarget.global_transform.origin, delta * follow_distance_speed)
#	var look_transform = camera.global_transform.looking_at(%ViewTarget.global_transform.origin, Vector3.UP)
#	camera.global_transform = camera.global_transform.interpolate_with(look_transform, delta * turn_speed)

