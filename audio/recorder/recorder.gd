extends Node

var recording : AudioStreamWAV

@onready var record_bus_index := AudioServer.get_bus_index("Record")
@onready var effect : AudioEffectRecord = AudioServer.get_bus_effect(record_bus_index, 0)

func _ready():
	%AudioStreamRecord.playing = true

func start():
	effect.set_recording_active(true)
	EventLogger.add('recording','started')

func stop():
	recording = effect.get_recording()
	effect.set_recording_active(false)
	EventLogger.add('recording','stopped')

func save(suffix: String = ''):

	var file_name := "%s_%s_%s_%s_%s.wav" % [
		Session.study_id,
		Session.age_group,
		Session.run_id,
		Session.condition_id,
# 		TODO: not working
		Session.sentence_id if suffix.length() == 0 else "%s_%s" % [Session.sentence_id,suffix]
	]

	var save_file = "%s%s" % [Session.save_folder, file_name]
	recording.save_to_wav(save_file)
	EventLogger.add('recording','saved', save_file)
