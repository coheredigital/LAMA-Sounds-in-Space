extends Panel

signal new_session_started

var sessions_collection : PocketbaseCollection


func _ready():
	sessions_collection = Pocketbase.collection('sessions')

func is_new_session_ready() -> bool:
	if Session.study_id.length() > 0 and Session.age_group.length() > 0 and Session.run_id.length() > 0:
		return true
	return false

func _on_new_session_button_pressed():
	var session_response = await sessions_collection.create({
		"study_id": Session.study_id,
		"age_group": Session.age_group,
		"run_id": Session.run_id,
	})
	
	Session.session_id = session_response.get("id")
	await EventLogger.add('session','started')
#	create the session save directory
	DirAccess.make_dir_absolute("user://sessions/")
	DirAccess.make_dir_absolute(Session.save_folder)
	
	emit_signal("new_session_started")
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
