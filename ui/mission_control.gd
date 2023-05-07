extends Panel

signal game_started
signal session_ended

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
	await EventLogger.add('session','ended')
	self.emit_signal("session_ended")


func _on_end_session_cancel_button_pressed():
	%EndSessionConfirmation.visible = false


func _on_start_game_pressed():
	self.emit_signal("game_started")
