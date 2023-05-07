extends Node


signal session_id_changed(value: String)
signal study_id_changed(value: String)
signal age_group_changed(value: String)
signal run_id_changed(value: String)
signal type_changed(value: String)
signal sentence_id_changed(value: String)

var save_folder: String:
	get:
		return "user://sessions/%s/" % [Session.session_id]

var session_id : String :
	set(value):
		session_id = value
		print('Session ID: %s' % value)
		session_id_changed.emit(value)
		
var study_id: String = "ACME":
	set(value):
		study_id = value
		print('Study ID: %s' % value)
		study_id_changed.emit(value)

var age_group: String:
	set(value):
		age_group = value
		print('Age Group: %s' % value)
		age_group_changed.emit(value)

var run_id: String:
	set(value):
		run_id = value
		print('Run ID: %s' % value)
		run_id_changed.emit(value)

@export_enum("PRAC","TEST") var type: String = "TEST":
	set(value):
		type = value
		print('Session Type: %s' % value)
		type_changed.emit(value)
		
		
#@export_enum("SpSp","SpSo","ImSp","ImSo") var type : String
var stimuli_type: String:
	set(value):
		type = value
		print('Stimuli Type: %s' % value)
		type_changed.emit(value)


var sentence_id: String:
	set(value):
		sentence_id = value
		print('Sentence ID: %s' % value)
		sentence_id_changed.emit(value)
