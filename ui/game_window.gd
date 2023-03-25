extends Window

#@onready var dialog_balloon = %DialogueBalloon

# Called when the node enters the scene tree for the first time.
func _ready():
	var resource = load("res://dialogue/script.dialogue")
	show_dialogue_balloon(resource, "start")

#
func show_dialogue_balloon(resource: DialogueResource, title: String = "0", extra_game_states: Array = []) -> void:
	var BalloonScene = load("res://ui/dialogue_balloon/dialogue_balloon.tscn")
	var balloon: Node = BalloonScene.instantiate()
	add_child(balloon)
	balloon.start(resource, title, extra_game_states)


