extends Control

signal start_game_pressed

var sequence : DialogueResource  = load("res://dialogue/sequence.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready():
	show_dialogue_balloon(sequence, "start")
#	set title jump options
	var titles = get_titles()
	for title in titles:
		%TitleJump.add_item(title)


# extract the currently available sequence titles
func get_titles() -> PackedStringArray:
	var file: FileAccess = FileAccess.open("res://dialogue/sequence.dialogue", FileAccess.READ)
	var file_text: String = file.get_as_text()
	var titles = PackedStringArray([])
	var lines = file_text.split("\n")
	for line in lines:
		if line.begins_with("~ "):
			titles.append(line.substr(2).strip_edges())
	return titles


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


func _on_title_jump_item_selected(index):
	
	pass # Replace with function body.
