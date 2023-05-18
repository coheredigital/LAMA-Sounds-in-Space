extends Control

signal game_window_toggled

func _ready():
	Session.session_started.connect(_on_session_started)
	Session.session_ended.connect(_on_session_ended)

func _on_session_started():
	%SessionManager.visible = false
	%MissionControl.visible = true

func _on_session_ended():
	%SessionManager.visible = true
	%MissionControl.visible = false


func _on_mission_control_game_window_toggled():
	self.emit_signal("game_window_toggled")
