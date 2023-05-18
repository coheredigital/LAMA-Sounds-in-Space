@tool
extends Node

@onready var player = $AudioStreamPlayer
@export_dir var folder
@export_range(0.0,1.0) var volume := 1.0:
	set(value):
		volume = value
		if player:
			player.volume_db = lerp(-16.0,0.0,value)

var previous_screen := "idle"
var previous_analyzer_channel := "Analyze"
var events


func play(sentence_id: String) -> void:
#	get the file or cancel operation
	var filename = "%s/%s.wav" % [folder,sentence_id];
	var wav_file = load(filename);
	if not wav_file:
		push_warning('Stilumi not found: %s' % [filename])
		return

	print('Stimuli: %s' % [filename])
	previous_screen = Sequencer.screen
	Sequencer.screen = "playing"

	previous_analyzer_channel = AudioVisualizer.channel
#	wait for screen to change before playing
	await get_tree().create_timer(1.0).timeout
	player.stream = wav_file
	player.playing = true
	await EventLogger.add('stimuli','played',filename)

# restore sequence and visualizer state on finish
func _on_audio_stream_player_finished():
	Sequencer.screen = previous_screen
	AudioVisualizer.channel = previous_analyzer_channel
