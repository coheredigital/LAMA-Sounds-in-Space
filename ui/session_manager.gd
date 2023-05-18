extends Panel


func is_new_session_ready() -> bool:
	if Session.study_id.length() > 0 and Session.age_group.length() > 0 and Session.run_id.length() > 0:
		return true
	return false

func _on_new_session_button_pressed():

	Session.start()
	
	await EventLogger.add('session','started')
	
#	store info.json file
	var info_file_name = "%s%s" % [ Session.save_folder, 'info.json' ]
	var info_file = FileAccess.open(info_file_name, FileAccess.WRITE)
	var info_json = JSON.stringify({
		"session_id": Session.session_id,
		"study_id": Session.study_id,
		"age_group": Session.age_group,
		"run_id": Session.run_id,
		"create_timestamp": Session.unix_time,
		"create_datetime": Session.date_formatted,
	}, "\t", false)

	Session.session_started.emit()

	if info_file:
		info_file.store_string(info_json)
		info_file.close()

	%SessionList.update_list()



func _on_study_id_input_text_changed(new_text):
	Session.study_id = new_text
	%NewSessionButton.disabled = !is_new_session_ready()

func _on_age_group_input_text_changed(new_text):
	Session.age_group = new_text
	%NewSessionButton.disabled = !is_new_session_ready()

func _on_run_id_input_text_changed(new_text):
	Session.run_id = new_text
	%NewSessionButton.disabled = !is_new_session_ready()
