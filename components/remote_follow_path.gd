@tool
extends Path3D

const LOOK_ANGLE_LIMIT = Vector2(20.0,-180.0)

@export_range (0.0, 64.0, 0.1) var progress := 0.0 :
	set(value):
		progress = value
		update_progress(value)


@export_range (0.0, 1.0, 0.001) var progress_ratio := 0.0 :
	set(value):
		progress_ratio = value
		update_progress_ratio(value)





@export var view_angle := Vector2(0.0,0.0):
	set(value):
		view_angle.x = clamp(value.x, -1.0, 1.0)
		view_angle.y = clamp(value.y, -1.0, 1.0)
		update_view_angle(view_angle)

@onready var path_follow : PathFollow3D = %PathFollow
@onready var look_target : Node3D = %LookTarget
@onready var remote_transform : Node3D = %RemoteTransform

@export_range (4.0, 16.0, 0.1) var follow_speed := 16.0
@export_range (4.0, 16.0, 0.1) var turn_speed := 16.0
@export_range (0.1, 2.0, 0.1) var max_distance := 0.5


func _process(delta):
	var distance = remote_transform.position.distance_to(path_follow.position)
	var distance_ratio = clamp(smoothstep(0.0, max_distance, distance), 0.0,1.0)
	if distance > 0.01:
		var follow_distance_speed = lerp(0.1, follow_speed, distance_ratio);
		remote_transform.position = remote_transform.position.move_toward(path_follow.global_transform.origin, delta * follow_distance_speed)
	var look_transform = remote_transform.global_transform.looking_at(look_target.global_transform.origin, Vector3.UP)
	remote_transform.global_transform = remote_transform.global_transform.interpolate_with(look_transform, delta * turn_speed)


func update_progress(value: float, duration: float = 1.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress", value, duration).set_trans(Tween.TRANS_SINE)


func update_progress_ratio(value: float, duration: float = 1.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress_ratio", value, duration).set_trans(Tween.TRANS_SINE)


func update_view_angle(value: Vector2, duration: float = 1.0) -> void:
	if %LookTargetPivot:
		var tween = create_tween()
		var target_angle = Vector3(0.0,0.0,0.0)
		target_angle.x = value.x * LOOK_ANGLE_LIMIT.x
		target_angle.y = value.y * LOOK_ANGLE_LIMIT.y
		if tween:
			tween.tween_property(%LookTargetPivot, "rotation_degrees", target_angle, duration).set_trans(Tween.TRANS_LINEAR)
