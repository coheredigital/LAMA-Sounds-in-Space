@tool
extends Path3D

@export_range (0.0, 1.0, 0.01) var progress := 0.0 :
	set(value):
		progress = value
		update_postion(value)

@onready var path_follow : PathFollow3D = %PathFollow

func _ready():
	Sequencer.character_position_changed.connect(update_postion)

func update_postion(value: float, duration: float = 2.0) -> void:
	if path_follow:
		var tween = create_tween()
		tween.tween_property(path_follow, "progress_ratio", value, duration).set_trans(Tween.TRANS_SINE)



func update_look_angle(value: Vector2, duration: float = 1.0) -> void:
	pass
