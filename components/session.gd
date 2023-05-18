extends Node

const root_directory : String = "user://sessions/"

signal session_started()
signal session_ended
signal session_id_changed(value: String)
signal study_id_changed(value: String)
signal age_group_changed(value: String)
signal run_id_changed(value: String)
signal type_changed(value: String)
signal sentence_id_changed(value: String)


var save_folder: String:
	get:
		return "user://sessions/%s/" % [Session.session_id]

var unique_name : String :
	get:
		return "%s_%s_%s" % [
			Session.study_id,
			Session.age_group,
			Session.run_id
		]
		
var session_id : String :
	set(value):
		session_id = value
		session_id_changed.emit(value)		
		
var pocketbase_id : String 

var study_id: String = "ACME":
	set(value):
		study_id = value
		study_id_changed.emit(value)

var age_group: String:
	set(value):
		age_group = value
		age_group_changed.emit(value)

var run_id: String:
	set(value):
		run_id = value
		run_id_changed.emit(value)
