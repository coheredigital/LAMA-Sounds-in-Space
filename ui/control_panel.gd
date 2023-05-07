extends Control

signal game_started
signal end_session_pressed


func _on_session_manager_new_session_started():
	%SessionManager.visible = false
	%MissionControl.visible = true

func _on_mission_control_session_ended():
	%SessionManager.visible = true
	%MissionControl.visible = false

func _on_mission_control_game_started():
	self.emit_signal("game_started")
