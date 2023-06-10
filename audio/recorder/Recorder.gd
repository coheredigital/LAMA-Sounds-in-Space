extends Node

var recording : AudioStreamWAV

@onready var record_bus_index := AudioServer.get_bus_index("Record")
@onready var effect : AudioEffectRecord = AudioServer.get_bus_effect(record_bus_index, 0)

func start():
	effect.set_recording_active(true)
	EventLogger.add('recording','started')

func stop():
	recording = effect.get_recording()
	effect.set_recording_active(false)
	await EventLogger.add('recording','stopped')

func save(stimuli_type: String, sentence_id: String):

	var file_name := "%s_%s_%s_%s_%s.wav" % [
		Session.study_id,
		Session.age_group,
		Session.run_id,
		stimuli_type,
		sentence_id
	]

	var save_file = "%s%s" % [Session.save_folder, file_name]
	recording.save_to_wav(save_file)
	await EventLogger.add('recording','saved', save_file)
