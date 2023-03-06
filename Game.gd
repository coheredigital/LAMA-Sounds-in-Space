extends Node

@onready var viewport := get_node('/root')

@export var game_scene : PackedScene

func _ready():
	


func _unhandled_input(event):
	if event.is_action_pressed("screenshot"):
		var time = Time.get_datetime_dict_from_system()
		var unix_time = Time.get_unix_time_from_system()
		var image = viewport.get_texture().get_data()
		image.flip_y()
		var filepath = "screenshots/screenshot_%s%s%s-%s.png" % [time['year'],time['month'],time['day'],unix_time]
		image.save_png(filepath)
		print('Screenshot save: "%s" ' % filepath)


func _on_start_game_pressed():
	var game := game_scene.instantiate()
	self.add_child(game)
