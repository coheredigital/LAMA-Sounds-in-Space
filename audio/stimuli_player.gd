extends Node

@export_dir var folder

func play(name: String) -> void:
	print("%s/%s.wav" % [folder,name])

