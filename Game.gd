extends Node

@onready var viewport := get_node('/root')


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
	%GameWindow.visible = !%GameWindow.visible


func _on_mission_intro_pressed():
	var state_machine = %GameWindow/MissionStateTree.get("parameters/playback")
	state_machine.travel('intro')
	
	
func _on_mission_unlock_pressed():
	var state_machine = %GameWindow/MissionStateTree.get("parameters/playback")
	state_machine.travel('unlock_spaceship')


func _on_mission_approach_pressed():
	var state_machine = %GameWindow/MissionStateTree.get("parameters/playback")
	state_machine.travel('approach_spaceship')


func _on_mission_enter_pressed():
	var state_machine = %GameWindow/MissionStateTree.get("parameters/playback")
	state_machine.travel('enter_spaceship')


func _on_mission_launch_pressed():
	var state_machine = %GameWindow/MissionStateTree.get("parameters/playback")
	state_machine.travel('launch')


func _on_mission_stars_pressed():
	var state_machine = %GameWindow/MissionStateTree.get("parameters/playback")
	state_machine.travel('stars_light_up')



