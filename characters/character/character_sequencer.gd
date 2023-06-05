extends Node

signal action_changed(value: String)
signal position_changed(value: float, duration: float)
signal pivot_changed(value: float, duration: float)
signal tilt_changed(value: float, duration: float)
signal audio_played(sentence_id: String)




func action(target_action: String) -> void:
	action_changed.emit(target_action)

func move_to(progress: float, duration: float = 1.0) -> void:
	position_changed.emit(progress, duration)

func pivot(value: float = 0.0, duration: float = 1.0) -> void:
	pivot_changed.emit(value, duration)

func tilt(value: float = 0.0, duration: float = 1.0) -> void:
	tilt_changed.emit(value, duration)


func play_audio(sentence_id: String) -> void:
	audio_played.emit(sentence_id)
	
