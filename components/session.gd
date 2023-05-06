extends Node


signal study_name_changed(value: String)
signal age_group_changed(value: String)
signal run_id_changed(value: String)
signal type_changed(value: String)
signal sentence_id_changed(value: String)


var pocketbase_id: String:
	set(value):
		study_id = value
		print('Study ID: %s' % value)
		study_name_changed.emit(value)

var study_id: String = "ACME":
	set(value):
		study_id = value
		print('Study ID: %s' % value)
		study_name_changed.emit(value)

var age_group: int = 1:
	set(value):
		age_group = value
		print('Age Group: %s' % value)
		age_group_changed.emit(value)

var run_id: int = 1:
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
