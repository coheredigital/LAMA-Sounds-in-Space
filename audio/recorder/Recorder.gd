extends Node

var recording : AudioStreamWAV
var events : PocketbaseCollection

@onready var record_bus_index := AudioServer.get_bus_index("Record")
@onready var effect : AudioEffectRecord = AudioServer.get_bus_effect(record_bus_index, 0)

func _ready():
	events = Pocketbase.collection('events')

func start():
	effect.set_recording_active(true)
	await EventLogger.add('recording','start')

func stop():
	recording = effect.get_recording()
	effect.set_recording_active(false)
	await EventLogger.add('recording','stopped')

func save(stimuli_type: String, sentence_id: String):

	var time = Time.get_datetime_dict_from_system()
#	var unix_time = Time.get_unix_time_from_system()
#	var date = "%s%s%s" % [time['year'],time['month'],time['day']]

	var file_name := "%s_%s_%s_%s_%s.wav" % [
		Session.study_id,
		Session.age_group,
		Session.run_id,
		stimuli_type,
		sentence_id
	]

	var save_file = "%s%s" % [Session.save_folder, file_name]
	recording.save_to_wav(save_file)
	await EventLogger.add('recording','start', save_file)
