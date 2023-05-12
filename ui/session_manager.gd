extends Panel

var sessions_collection : PocketbaseCollection

func _ready():
	sessions_collection = Pocketbase.collection('sessions')

func is_new_session_ready() -> bool:
	if Session.study_id.length() > 0 and Session.age_group.length() > 0 and Session.run_id.length() > 0:
		return true
	return false

func _on_new_session_button_pressed():
	
	var time = Time.get_datetime_dict_from_system()
	var unix_time = Time.get_unix_time_from_system()
	var date = "%s/%s/%s %s:%s:%s" % [
		time['year'],
		"%02d" % time['month'],
		"%02d" % time['day'],
		"%02d" % time['hour'],
		"%02d" % time['minute'],
		"%02d" % time['second']
	]
	
	var date_id = "%s%s%s-%s%s%s" % [
		time['year'],
		"%02d" % time['month'],
		"%02d" % time['day'],
		"%02d" % time['hour'],
		"%02d" % time['minute'],
		"%02d" % time['second']
	]

	Session.session_id = "%s__%s" % [date_id,Session.unique_name]
	
	var session_response = await sessions_collection.create({
		"study_id": Session.study_id,
		"age_group": Session.age_group,
		"run_id": Session.run_id,
		"folder": Session.save_folder,
	})
	Session.pocketbase_id = session_response.get("id")

	
	await EventLogger.add('session','started')
#	create the session save directory
	DirAccess.make_dir_recursive_absolute(Session.save_folder)
	
#	store info.json file
	var info_file_name = "%s%s" % [ Session.save_folder, 'info.json' ]
	var info_file = FileAccess.open(info_file_name, FileAccess.WRITE)
	var info_json = JSON.stringify({
		"session_id": Session.session_id,
		"study_id": Session.study_id,
		"age_group": Session.age_group,
		"run_id": Session.run_id,
		"create_timestamp": unix_time,
		"create_datetime": date,
	})
	
#	create the session resource file and save the .tres with the session data
	var session_resource = SessionResource.new()
	session_resource.create_unix_time = unix_time
	session_resource.create_dateime = date
	print("SessiomResource %s:" % [session_resource.get_instance_id()])
	
	ResourceSaver.save( session_resource,"%s%s" % [Session.save_folder,'session.tres'])

	if info_file:
		info_file.store_string(info_json)
		info_file.close()


	Session.session_started.emit(session_resource)
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
