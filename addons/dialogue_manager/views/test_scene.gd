extends Node2D


@onready var settings = $Settings


func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1280, 720))
	get_window().size = Vector2(1280, 720)
	get_window().position = (DisplayServer.screen_get_size() - get_window().size) * 0.5
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (false) else Window.MODE_WINDOWED
	
	DialogueManager.connect("dialogue_finished",Callable(self,"_on_dialogue_finished"))
	
	var title = settings.get_user_value("run_title")
	var dialogue_resource = load(settings.get_user_value("run_resource_path"))
	DialogueManager.show_example_dialogue_balloon(title, dialogue_resource)


### Signals


func _on_dialogue_finished():
	get_tree().quit()
