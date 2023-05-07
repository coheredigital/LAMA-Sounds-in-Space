extends Panel

signal new_session_started

var sessions_collection : PocketbaseCollection



# Called when the node enters the scene tree for the first time.
func _ready():
	sessions_collection = Pocketbase.collection('sessions')
	var list = await sessions_collection.get_list(1,20)
	for item in list.get('items'):
		%SessionList.add_item("Session ID: %s   Study ID: %s   Age Group: %s   Run ID: %s" % [
			item.get("id"),
			item.get("study_id"),
			item.get("age_group"),
			item.get("run_id"),
		])

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
	emit_signal("new_session_started")

func _on_study_id_input_text_changed(new_text):
	Session.study_id = new_text
	%NewSessionButton.disabled = !is_new_session_ready()

func _on_age_group_input_text_changed(new_text):
	Session.age_group = new_text
	%NewSessionButton.disabled = !is_new_session_ready()

func _on_run_id_input_text_changed(new_text):
	Session.run_id = new_text
	%NewSessionButton.disabled = !is_new_session_ready()
