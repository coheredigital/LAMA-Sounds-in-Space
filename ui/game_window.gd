extends Window


# Called when the node enters the scene tree for the first time.
func _ready():
	var resource = load("res://dialog/intro.dialogue")
	DialogueManager.show_example_dialogue_balloon(resource, "start")
