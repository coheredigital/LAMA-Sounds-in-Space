extends Node

signal study_name_changed(value: String)
signal age_group_changed(value: String)
signal run_id_changed(value: String)
signal type_changed(value: String)


@export var study_name: String = "ACME":
	set(value):
		study_name = value
		print('Study Name: %s' % value)
		study_name_changed.emit(value)

@export var age_group: String = "01":
	set(value):
		age_group = value
		print('Age Group: %s' % value)
		age_group_changed.emit(value)

@export var run_id: int = 1:
	set(value):
		run_id = value
		print('Run ID: %s' % value)
		run_id_changed.emit(value)

#@export_enum("PRAC","TEST") var type: String = "TEST":
@export var type: String = "TEST":
	set(value):
		type = value
		print('Session Type: %s' % value)
		type_changed.emit(value)
		
		
#@export_enum("SpSp","SpSo","ImSp","ImSo") var type : String
@export var stimuli_type: String = "SpSo":
	set(value):
		type = value
		print('Stimuli Type: %s' % value)
		type_changed.emit(value)
