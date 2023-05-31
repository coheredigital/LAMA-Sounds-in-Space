@tool
extends Node3D

@export_enum("idle","talking") var action: String = "idle":
	set(value):
		action = value
		if state_tree:
			var action_state : AnimationNodeStateMachinePlayback = state_tree.get("parameters/action/playback")
			action_state.travel(action)
@export_dir var audio_folder
@onready var state_tree := %StateTree
@onready var player = %AudioPlayer

func _ready():
	Sequencer.character_action_changed.connect(update_action)
	Character.audio_played.connect(play_audio)

func update_state(value: String) -> void:
	if state_tree:
		var state_machine = state_tree.get("parameters/position/playback")
		state_machine.travel(value)

func update_action(value: String) -> void:
	if state_tree:
		var state_machine = state_tree.get("parameters/action/playback")
		state_machine.travel(value)


func play_audio(sentence_id: String) -> void:
#	get the file or cancel operation
	var filename = "%s/%s.wav" % [audio_folder,sentence_id];
	var wav_file = load(filename);
	if not wav_file:
		push_warning('Script line not found: %s' % [filename])
		return
	print('Script: %s' % [filename])
	player.stream = wav_file
	player.playing = true
	await EventLogger.add('script','played',filename)
