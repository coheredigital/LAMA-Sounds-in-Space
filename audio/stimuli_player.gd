extends Node

@onready var player = $AudioStreamPlayer

@export_dir var folder


func play(sentence_id: String) -> void:
	var filename = "%s/%s.wav" % [folder,sentence_id];
	
	var wav_file = load(filename);
	
	if not wav_file:
		push_warning('Stilumi not found: %s' % [filename])
		return
	
	print('Stimuli: %s' % [filename])

	player.stream = wav_file
	player.playing = true
		
