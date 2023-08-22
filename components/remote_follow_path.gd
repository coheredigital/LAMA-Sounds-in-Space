@tool
extends Path3D

const LOOK_ANGLE_LIMIT = Vector2(20.0,180.0)

@export_range (0.0, 1.0, 0.01) var progress_ratio := 0.0 :
	set(value):
		progress_ratio = value
		update_progress_ratio(value)

@export_range (-1.0, 1.0, 0.01) var pivot := 0.0:
	set(value):
		pivot = clamp(value, -1.0, 1.0)
		update_pivot(pivot * -1.0)

@export_range (-1.0, 1.0, 0.05) var tilt := 0.0:
	set(value):
		tilt = clamp(value, -1.0, 1.0)
		update_tilt(tilt * -1.0)

@export_group("Follow Config")
#@export_range (1.0, 8.0, 0.1) var follow_speed := 4.0
const follow_speed := 4.0
#@export_range (1.0, 8.0, 0.1) var turn_speed := 4.0
const turn_speed := 2.0
#@export_range (1.0, 4.0, 0.1) var max_distance := 2.0
const max_distance := 1.0

@onready var path_follow : PathFollow3D = %PathFollow
@onready var look_target : Node3D = %LookTarget
@onready var remote_transform : Node3D = %RemoteTransform
@onready var look_target_pivot : Node3D = %LookTargetPivot
@onready var look_target_tilt : Node3D = %LookTargetTilt


func _process(delta):
#	prevent global offset
	self.position = Vector3(0.0,0.0,0.0)
	self.rotation = Vector3(0.0,0.0,0.0)
	
	
	var distance = remote_transform.position.distance_to(path_follow.position)
	var distance_ratio = clamp(smoothstep(0.0, max_distance, distance), 0.0,1.0)
	if distance > 0.01:
		var follow_distance_speed = lerp(0.1, follow_speed, distance_ratio);
		remote_transform.position = remote_transform.position.move_toward(path_follow.global_transform.origin, delta * follow_distance_speed)
	var look_transform = remote_transform.global_transform.looking_at(look_target.global_transform.origin, Vector3.UP)
	remote_transform.global_transform = remote_transform.global_transform.interpolate_with(look_transform, delta * turn_speed)

func update_progress_ratio(value: float, duration: float = 1.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress_ratio", value, duration).set_trans(Tween.TRANS_LINEAR)

func update_pivot(value: float, duration: float = 1.0) -> void:
	if look_target_pivot:
		var tween = create_tween()
		var traget_rotation = clamp(value,-1.0,1.0) * LOOK_ANGLE_LIMIT.y
		var target_angle = Vector3(0.0,traget_rotation,0.0)
		if tween:
			tween.tween_property(look_target_pivot, "rotation_degrees", target_angle, duration).set_trans(Tween.TRANS_LINEAR)

func update_tilt(value: float, duration: float = 1.0) -> void:
	if look_target_tilt:
		var tween = create_tween()
		var traget_rotation = clamp(value,-1.0,1.0) * LOOK_ANGLE_LIMIT.x
		var target_angle = Vector3(traget_rotation,0.0,0.0)
		if tween:
			tween.tween_property(look_target_tilt, "rotation_degrees", target_angle, duration).set_trans(Tween.TRANS_LINEAR)

