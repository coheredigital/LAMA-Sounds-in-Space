extends Control


@onready var profiler_overlay = $ProfilerOverlay


func _unhandled_input(event):
	if event.is_action_pressed("toggle_debug"):
		visible = !visible


func _ready():
#	set the children to match the parent stae in editor
	DebugTools.set_visibility(visible)
	profiler_overlay.set_visibility(visible)
#	make parent visible so individual elements can be toggled
	visible = true
