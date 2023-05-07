extends Node

var recording : AudioStreamWAV
var events : PocketbaseCollection

@onready var record_bus_index := AudioServer.get_bus_index("Record")
@onready var effect : AudioEffectRecord = AudioServer.get_bus_effect(record_bus_index, 0)

func _ready():
	events = Pocketbase.collection('events')

func start():
	effect.set_recording_active(true)
	await events.create({
		"type": 'recording_start',
		"session": Session.session_id
	})

func stop():
	recording = effect.get_recording()
	effect.set_recording_active(false)
	await events.create({
		"type": 'recording_stopped',
		"session": Session.session_id
	})

func save(stimuli_type: String, sentence_id: String):
	
	var time = Time.get_datetime_dict_from_system()
#	var unix_time = Time.get_unix_time_from_system()
	var folder_name := Session.study_id
	var file_name := "%s_%s_%s_%s_%s.wav" % [ 
		Session.study_id, 
		Session.age_group,
		Session.run_id,
		stimuli_type,
		sentence_id
	]
	
#	var date = "%s%s%s" % [time['year'],time['month'],time['day']]
	var save_folder = "user://recordings/%s/" % [folder_name]
	var save_file = "%s%s" % [save_folder, file_name]
#	DirAccess.make_dir_absolute(save_folder)
	DirAccess.make_dir_absolute("user://recordings/")
	DirAccess.make_dir_absolute(save_folder)
	recording.save_to_wav(save_file)
	print("Saved: %s" % [save_file])
	
	await events.create({
		"type": 'recording_saved',
		"info": save_file,
		"session": Session.session_id
	})

