extends Control


@onready var profiler_overlay = $ProfilerOverlay


func _unhandled_input(event):
	if event.is_action_pressed("toggle_debug"):
		visible = !visible
