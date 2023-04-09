@tool
extends Path3D

@export_range (0.0, 1.0, 0.01) var progress := 0.0 :
	set(value):
		progress = value
		update_postion(value)

@onready var path_follow : PathFollow3D = $PathFollow
@onready var remote_transform := $PathFollow/RemoteTransform3D

func update_postion(value: float, duration: float = 2.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress_ratio", value, duration).set_trans(Tween.TRANS_SINE)


