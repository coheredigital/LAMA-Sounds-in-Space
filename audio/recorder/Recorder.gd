extends Node

var recording : AudioStreamWAV

@onready var record_bus_index := AudioServer.get_bus_index("Record")
@onready var effect : AudioEffectRecord = AudioServer.get_bus_effect(record_bus_index, 0)

func start():
	print("Recording...")
	effect.set_recording_active(true)

func stop():
	print("STOP!")
	recording = effect.get_recording()
	effect.set_recording_active(false)

func save():
	var time = Time.get_datetime_dict_from_system()
	var unix_time = Time.get_unix_time_from_system()
	var folder_name := Session.study_id
	var file_name := "%s_%s_%s_%s_%s.wav" % [ 
		Session.study_id, 
		Session.age_group,
		Session.run_id,
		Session.type,
		Session.sentence_id
	]
	
	var date = "%s%s%s" % [time['year'],time['month'],time['day']]
	var save_folder = "user://recordings/%s/" % [folder_name]
	var save_file = "%s%s" % [save_folder, file_name]
#	DirAccess.make_dir_absolute(save_folder)
	DirAccess.make_dir_absolute("user://recordings/")
	DirAccess.make_dir_absolute(save_folder)
#	recording.save_to_wav("user://recordings/file.wav")
	recording.save_to_wav(save_file)
	print("Saved: %s" % [save_file])
