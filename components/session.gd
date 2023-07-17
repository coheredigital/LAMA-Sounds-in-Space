extends Node

const root_directory : String = "user://sessions/"

signal session_started()
signal session_ended
signal session_id_changed(value: String)
signal age_group_changed(value: String)
signal run_id_changed(value: String)
signal stimuli_type_changed(value: String)
signal study_id_changed(value: String)
signal sentence_id_changed(value: String)
signal player_control_enabled(value: bool)
signal user_clicked


var unix_time : float
var datetime : Dictionary

var save_folder: String:
	get:
		return "user://sessions/%s/" % [Session.session_id]

var date_formatted : String :
	get:
		return "%s/%s/%s %s:%s:%s" % [
			datetime['year'],
			"%02d" % datetime['month'],
			"%02d" % datetime['day'],
			"%02d" % datetime['hour'],
			"%02d" % datetime['minute'],
			"%02d" % datetime['second']
		]
		
var unique_name : String :
	get:
		return "%s_%s_%s" % [
			study_id,
			age_group,
			run_id
		]
		
var session_id : String :
	get:
#		create a date string safe for use in folder name
		if not datetime.size():
			return ''
			
		var date_id = "%s%s%s-%s%s%s" % [
			datetime['year'],
			"%02d" % datetime['month'],
			"%02d" % datetime['day'],
			"%02d" % datetime['hour'],
			"%02d" % datetime['minute'],
			"%02d" % datetime['second']
		]
		return "%s__%s" % [date_id,Session.unique_name]


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

var sentence_id: String:
	set(value):
		sentence_id = value
		sentence_id_changed.emit(value)

func _ready():
	unix_time = Time.get_unix_time_from_system()
	datetime = Time.get_datetime_dict_from_system()

func start():
	unix_time = Time.get_unix_time_from_system()
	datetime = Time.get_datetime_dict_from_system()
	#	create the session save directory
	DirAccess.make_dir_recursive_absolute(self.save_folder)
