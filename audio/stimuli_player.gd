#@tool
extends Node

signal stimuli_player_started
signal stimuli_player_finished

@onready var player := %AudioStreamPlayer
@export_dir var folder
@export_range(0.0,1.0) var volume := 1.0:
	set(value):
		volume = value
		if player:
			player.volume_db = lerp(-16.0,0.0,value)


func play(sentence_id: String) -> void:
#	get the file or cancel operation
	var filename = "%s/%s.wav" % [folder,sentence_id];
	print('Play stimuli: %s' % [filename])
	
	var wav_file = load(filename);
	if not wav_file:
		push_warning('Stilumi file not found: %s' % [filename])
		return

#	Visualizer.channel = "Stimuli"
#	delay for screen to change before playing
	await get_tree().create_timer(1.0).timeout
	player.stream = wav_file
	player.playing = true
	Session.sentence_id = sentence_id
	EventLogger.add('stimuli','played',filename)

# restore sequence and visualizer state on finish
func _on_audio_stream_player_finished():
	await get_tree().create_timer(1.0).timeout
#	Visualizer.channel = "Analyze"
	stimuli_player_finished.emit()
