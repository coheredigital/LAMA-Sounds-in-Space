extends Control

signal start_game_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	var resource = load("res://dialogue/script.dialogue")
	show_dialogue_balloon(resource, "start")
	
func _process(delta):
	%StatusBarLabel.text = "Session Type: %s  Stimuili: %s  Sentence ID: %s" % [Session.type, Session.stimuli_type, Session.sentence_id]

func show_dialogue_balloon(resource: DialogueResource, title: String = "0", extra_game_states: Array = []) -> void:
	%ControlBalloon.start(resource, title, extra_game_states)

func _on_study_id_text_changed(text : String):
	Session.study_id = text

func _on_age_group_value_changed(value):
	Session.age_group = value

func _on_run_id_value_changed(value):
	Session.run_id

func _on_start_game_pressed():
	self.emit_signal("start_game_pressed")
