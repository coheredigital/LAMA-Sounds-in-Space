extends Node

var state: String = "intro":
	set(value):
		state = value
		update_state(value)

@onready var state_tree := %StateTree
@onready var character_path := %CharacterPath

func _ready():
	Sequencer.level_changed.connect(update_state)
	Sequencer.character_position_changed.connect(update_character_postion)
	
	
func update_state(value: String) -> void: 
	if state_tree:
		var state_machine : AnimationNodeStateMachinePlayback = state_tree.get("parameters/playback")
		state_machine.travel(value)
		
func update_character_postion(value: float, duration: float = 2.0) -> void: 
	if character_path:
		var tween = create_tween()
		tween.tween_property(character_path, "progress_ratio", value, duration).set_trans(Tween.TRANS_SINE)
