@tool
extends Path3D

const LOOK_ANGLE_LIMIT = Vector2(40.0,40.0)

@export_range (0.0, 64.0, 0.1) var progress := 0.0 :
	set(value):
		progress = value
		update_progress(value)


@export_range (0.0, 1.0, 0.001) var progress_ratio := 0.0 :
	set(value):
		progress_ratio = value
		update_progress_ratio(value)


@export_range (0.0, 2.0, 0.1) var look_height := 1.0:
	set(value):
		look_height = value
		
		if look_target:
			look_target.position.y = look_height


@export var look_angle := Vector2(0.0,0.0):
	set(value):
		look_angle = clamp(value, Vector2(-1.0,-1.0), Vector2(1.0,1.0))
		update_look_angle(look_angle)

@onready var path_follow : PathFollow3D = $PathFollow
@onready var look_target : Marker3D = %LookTarget
@onready var remote_transform := $PathFollow/RemoteTransform3D

func update_progress(value: float, duration: float = 2.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress", value, duration).set_trans(Tween.TRANS_SINE)

func update_progress_ratio(value: float, duration: float = 2.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress_ratio", value, duration).set_trans(Tween.TRANS_SINE)


func update_look_angle(value: Vector2, duration: float = 2.0) -> void:
	if look_target:
		var tween = create_tween()
		var target_angle = Vector3(0.0,0.0,0.0)
		target_angle.x = value.x * LOOK_ANGLE_LIMIT.x
		target_angle.x = value.y * LOOK_ANGLE_LIMIT.y
		tween.tween_property(look_target, "rotation_degrees", target_angle, duration).set_trans(Tween.TRANS_SINE)
