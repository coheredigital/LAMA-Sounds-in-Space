extends Control

@onready var performance_monitor = $Container/MonitorOverlay

func _input(event):
	if event.is_action_pressed("toggle_profiler") and performance_monitor:
		set_visibility(!performance_monitor.visible)

func set_visibility(state: bool):
	if performance_monitor:
		performance_monitor.visible = state
