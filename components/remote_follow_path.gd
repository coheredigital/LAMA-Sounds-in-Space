@tool
extends Path3D

@export_range (0.0, 64.0, 0.1) var progress := 0.0 :
	set(value):
		progress = value
		update_progress(value)

@export_range (0.0, 1.0, 0.001) var progress_ratio := 0.0 :
	set(value):
		progress_ratio = value
		update_progress_ratio(value)


@onready var path_follow : PathFollow3D = $PathFollow
@onready var remote_transform := $PathFollow/RemoteTransform3D

func update_progress(value: float, duration: float = 2.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress", value, duration).set_trans(Tween.TRANS_SINE)

func update_progress_ratio(value: float, duration: float = 2.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress_ratio", value, duration).set_trans(Tween.TRANS_SINE)


