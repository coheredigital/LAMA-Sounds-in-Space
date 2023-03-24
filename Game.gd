extends Node



func _on_start_game_pressed():
	%GameWindow.visible = !%GameWindow.visible


func _unhandled_input(event):
	if event.is_action_pressed("screenshot"):
		print('screenshot')
		var time = Time.get_datetime_dict_from_system()
		var unix_time = Time.get_unix_time_from_system()
		var image = %GameWindow/ViewportContainer/Viewport.get_texture().get_image()
		var filepath = "screenshots/screenshot_%s%s%s-%s.png" % [time['year'],time['month'],time['day'],unix_time]
		image.save_png(filepath)
		print('Screenshot save: "%s" ' % filepath)
