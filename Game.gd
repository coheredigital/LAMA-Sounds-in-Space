extends Node

@onready var sessions_collection := Pocketbase.collection('sessions')


func _ready():
	Pocketbase.start_server()
	var session_response = await sessions_collection.create({
		"study_id": Session.study_id,
		"age_group": Session.age_group,
		"run_id": Session.run_id,
	})
	print(session_response)
	Session.pocketbase_id = session_response.get("id")
	
	
func _exit_tree():
	Pocketbase.stop_server()

func _unhandled_input(event):
	if event.is_action_pressed("screenshot"):
		print('screenshot')
		var time = Time.get_datetime_dict_from_system()
		var unix_time = Time.get_unix_time_from_system()
		var image = %GameWindow/ViewportContainer/Viewport.get_texture().get_image()
		var filepath = "screenshots/screenshot_%s%s%s-%s.png" % [time['year'],time['month'],time['day'],unix_time]
		image.save_png(filepath)
		print('Screenshot save: "%s" ' % filepath)

func _on_control_panel_start_game_pressed():
	%GameWindow.visible = !%GameWindow.visible
