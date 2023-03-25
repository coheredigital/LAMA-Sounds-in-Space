extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var resource = load("res://dialogue/script.dialogue")
	show_dialogue_balloon(resource, "load")


func show_dialogue_balloon(resource: DialogueResource, title: String = "0", extra_game_states: Array = []) -> void:
 	%ControlBalloon.start(resource, title, extra_game_states)
