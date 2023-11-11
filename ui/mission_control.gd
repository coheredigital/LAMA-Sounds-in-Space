extends Panel

signal game_window_toggled(is_open: bool)


var sequence : DialogueResource  = load("res://dialogue/sequence.dialogue")

func _ready():
	Session.session_started.connect(func():  %GameWindowsToggle.button_pressed = true)
	%EndSessionConfirmation.visible = false
	%ControlBalloon.start(sequence, "start")

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

func _on_game_window_toggled(button_pressed):
	self.emit_signal("game_window_toggled", button_pressed)
