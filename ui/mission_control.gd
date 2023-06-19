extends Panel

signal game_window_toggled(is_open: bool)

var sequence : DialogueResource  = load("res://dialogue/sequence.dialogue")

func _ready():
	%EndSessionConfirmation.visible = false
	%ControlBalloon.start(sequence, "start")

# extract the currently available sequence titles
#func get_titles() -> PackedStringArray:
#	var file: FileAccess = FileAccess.open("res://dialogue/sequence.dialogue", FileAccess.READ)
#	var file_text: String = file.get_as_text()
#	var titles = PackedStringArray([])
#	var lines = file_text.split("\n")
#	for line in lines:
#		if line.begins_with("~ "):
#			titles.append(line.substr(2).strip_edges())
#	return titles


func _on_end_session_button_pressed():
	%EndSessionConfirmation.visible = true

func _on_end_session_confirm_button_pressed():
	%EndSessionConfirmation.visible = false
	if %ControlBalloon:
		%ControlBalloon.start(sequence, "start")
	Session.session_ended.emit()	
	EventLogger.add('session','ended')

func _on_end_session_cancel_button_pressed():
	%EndSessionConfirmation.visible = false


func _on_check_button_toggled(button_pressed):
	self.emit_signal("game_window_toggled", button_pressed)
