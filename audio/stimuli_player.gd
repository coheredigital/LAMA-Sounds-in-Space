extends Node

@export_dir var folder

func play(sentence_id: String) -> void:
	var filename = "%s/%s.wav" % [folder,sentence_id];
	
	var wav_file = load(filename);
	
	if wav_file:
		print(wav_file)
	else:
		push_warning('Stilumi not found: %s' % [filename])
