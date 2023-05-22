extends Node

@onready var mission_control = $ControlPanel/MainContainer/MissionControl



func _ready():
	Session.session_ended.connect(func(): %GameWindow.visible = false)
	%GameWindow.visible = false

func _unhandled_input(event):
	
	if event.is_action_pressed("screenshot"):
		print('screenshot')
		var time = Time.get_datetime_dict_from_system()
		var unix_time = Time.get_unix_time_from_system()
		var image = %GameWindow/ViewportContainer/Viewport.get_texture().get_image()
		var filepath = "screenshots/screenshot_%s%s%s-%s.png" % [time['year'],time['month'],time['day'],unix_time]
		image.save_png(filepath)
		print('Screenshot save: "%s" ' % filepath)


func _on_control_panel_game_window_toggled(is_open):
	%GameWindow.visible = is_open


func _on_game_window_window_input(event : InputEvent):
	if event.is_action_pressed("confirm"):
		Session.user_clicked.emit()

