extends Node

var state: String = "intro":
	set(value):
		state = value
		update_state(value)

@onready var state_tree := %StateTree
@onready var character_path := %CharacterPath
@onready var player_path := %PlayerPath
@onready var alien_path := %AlienPath
@onready var ufo_path := %UfoPath
@onready var lama_path := %LamaPath

func _ready():
#	Global Sequencer
	Sequencer.level_changed.connect(update_state)
	
#	TODO: Simplify pattern
#	Player
	Player.position_changed.connect(update_player_position)
	Player.pivot_changed.connect(update_player_pivot)
	Player.tilt_changed.connect(update_player_tilt)
	
#	Character (Sam)
	Character.position_changed.connect(update_character_postion)
	Character.pivot_changed.connect(update_character_pivot)
	Character.tilt_changed.connect(update_character_tilt)
	
#	Alien
	Alien.position_changed.connect(update_alien_postion)
	Alien.pivot_changed.connect(update_alien_pivot)
	Alien.tilt_changed.connect(update_alien_tilt)
	
#	Lama
	Lama.position_changed.connect(update_lama_postion)
	Lama.pivot_changed.connect(update_lama_pivot)
	Lama.tilt_changed.connect(update_lama_tilt)
	Lama.rescued_state_changed.connect(update_lama_visibility)

#	UFO
	Ufo.position_changed.connect(update_ufo_postion)
	Ufo.pivot_changed.connect(update_ufo_pivot)
	Ufo.tilt_changed.connect(update_ufo_tilt)	

# Control the over "level" state (home, launch, warp, landing)
func update_state(value: String) -> void: 
	if state_tree:
		var state_machine : AnimationNodeStateMachinePlayback = state_tree.get("parameters/playback")
		state_machine.travel(value)

# Generic Path update functions
func update_path_position(path: Path3D, position: float, duration: float = 1.0) -> void: 
	if path:
		var tween = create_tween()
		tween.tween_property(path, "progress_ratio", position, duration).set_trans(Tween.TRANS_SINE)

func update_path_pivot(path: Path3D, pivot: float, duration: float = 1.0) -> void: 
	if path:
		var tween = create_tween()
		tween.tween_property(path, "pivot", pivot, duration).set_trans(Tween.TRANS_SINE)
		
func update_path_tilt(path: Path3D, tilt: float, duration: float = 1.0) -> void: 
	if path:
		var tween = create_tween()
		tween.tween_property(path, "tilt", tilt, duration).set_trans(Tween.TRANS_SINE)
		
# Player 
func update_player_position(position: float, duration: float = 1.0) -> void: 
	update_path_position(player_path,position,duration)

func update_player_pivot(pivot: float, duration: float = 1.0) -> void: 
	update_path_pivot(player_path,pivot,duration)

func update_player_tilt(tilt: float, duration: float = 1.0) -> void: 
	update_path_tilt(player_path,tilt,duration)

#	Character (Sam)
func update_character_postion(position: float, duration: float = 1.0) -> void: 
	update_path_position(character_path,position,duration)

func update_character_pivot(pivot: float, duration: float = 1.0) -> void: 
	update_path_pivot(character_path,pivot,duration)

func update_character_tilt(tilt: float, duration: float = 1.0) -> void: 
	update_path_tilt(character_path,tilt,duration)


#	Alien
func update_alien_postion(position: float, duration: float = 1.0) -> void: 
	update_path_position(alien_path,position,duration)

func update_alien_pivot(pivot: float, duration: float = 1.0) -> void: 
	update_path_pivot(alien_path,pivot,duration)

func update_alien_tilt(tilt: float, duration: float = 1.0) -> void: 
	update_path_tilt(alien_path,tilt,duration)


#	Lama
func update_lama_postion(position: float, duration: float = 1.0) -> void: 
	update_path_position(lama_path,position,duration)

func update_lama_pivot(pivot: float, duration: float = 1.0) -> void: 
	update_path_pivot(lama_path,pivot,duration)

func update_lama_tilt(tilt: float, duration: float = 1.0) -> void: 
	update_path_tilt(lama_path,tilt,duration)
	
func update_lama_visibility(state: bool) -> void: 
	if state:
		%LamaRescued.visible = true
		%LamaLost.visible = false
	else:
		%LamaRescued.visible = false
		%LamaLost.visible = true

	
#	UFO
func update_ufo_postion(position: float, duration: float = 1.0) -> void: 
	update_path_position(ufo_path,position,duration)

func update_ufo_pivot(pivot: float, duration: float = 1.0) -> void: 
	update_path_pivot(ufo_path,pivot,duration)

func update_ufo_tilt(tilt: float, duration: float = 1.0) -> void: 
	update_path_tilt(ufo_path,tilt,duration)
	
