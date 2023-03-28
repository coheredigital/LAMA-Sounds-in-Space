extends Node

var recording : AudioStreamWAV

@export var folder_name := 'default'
@export var file_name := 'recording'

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
	var date_string = "%s%s%s-%s" % [time['year'],time['month'],time['day'],unix_time]
	var save_path = "user://%s/%s_%s.wav" % [folder_name, file_name, date_string]
	DirAccess.make_dir_absolute("user://%s/" % folder_name)
	recording.save_to_wav(save_path)
	print("Saved: %s" % [save_path])
