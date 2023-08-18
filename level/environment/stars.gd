@tool
extends Node3D

@export_range(0.0, 1.0, 0.1) var star1_progress := 0.0: 
	set(value):
		star1_progress = value
		set_star_progess(1,value)
@export_range(0.0, 1.0, 0.1) var star2_progress := 0.0: 
	set(value):
		star2_progress = value
		set_star_progess(2,value)
@export_range(0.0, 1.0, 0.1) var star3_progress := 0.0: 
	set(value):
		star3_progress = value
		set_star_progess(3,value)
@export_range(0.0, 1.0, 0.1) var star4_progress := 0.0: 
	set(value):
		star4_progress = value
		set_star_progess(4,value)
@export_range(0.0, 1.0, 0.1) var star5_progress := 0.0: 
	set(value):
		star5_progress = value
		set_star_progess(5,value)		
@export_range(0.0, 1.0, 0.1) var star6_progress := 0.0: 
	set(value):
		star6_progress = value
		set_star_progess(6,value)
@export_range(0.0, 1.0, 0.1) var star7_progress := 0.0: 
	set(value):
		star7_progress = value
		set_star_progess(7,value)		
@export_range(0.0, 1.0, 0.1) var star8_progress := 0.0: 
	set(value):
		star8_progress = value
		set_star_progess(8,value)		
@export_range(0.0, 1.0, 0.1) var star9_progress := 0.0: 
	set(value):
		star9_progress = value
		set_star_progess(9,value)		
@export_range(0.0, 1.0, 0.1) var star10_progress := 0.0: 
	set(value):
		star10_progress = value
		set_star_progess(10,value)		
@export_range(0.0, 1.0, 0.1) var star11_progress := 0.0: 
	set(value):
		star11_progress = value
		set_star_progess(11,value)		
@export_range(0.0, 1.0, 0.1) var star12_progress := 0.0: 
	set(value):
		star12_progress = value
		set_star_progess(12,value)

@onready var paths := %Paths

func _ready():
	Sequencer.star_moved.connect(set_star_progess)


func set_star_progess(star_number: int, progress: float, duration: float = 1.0) -> void:
	if paths:
		var star_path = paths.find_child('StarPath3D%s' % star_number)
		if star_path:
			var path_follow : PathFollow3D = star_path.find_child('PathFollow3D')
			if path_follow:
				var tween = create_tween()
				if tween:
					tween.tween_property(path_follow, "progress_ratio", progress, duration).set_trans(Tween.TRANS_SINE)
