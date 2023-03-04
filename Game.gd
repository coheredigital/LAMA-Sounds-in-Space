extends Node

@onready var viewport := get_node('/root')



func _ready():
	var dialogue_resource = preload("res://dialogue/test_dialogue.tres")
	DialogueManager.show_example_dialogue_balloon("this_is_a_node_title", dialogue_resource)
	get_window().set_current_screen(1)

func _unhandled_input(event):
	if event.is_action_pressed("screenshot"):
		var time = Time.get_datetime_dict_from_system()
		var unix_time = Time.get_unix_time_from_system()
		var image = viewport.get_texture().get_data()
		image.flip_y()
		var filepath = "screenshots/screenshot_%s%s%s-%s.png" % [time['year'],time['month'],time['day'],unix_time]
		image.save_png(filepath)
		print('Screenshot save: "%s" ' % filepath)
