extends Window



func _ready():
	Sequencer.player_position_changed.connect(update_player_position)

func update_player_position(position: float, duration: float = 1.0):

	if %PlayerFollowPath:
		var tween = create_tween()
		tween.tween_property(%PlayerFollowPath, "progress_ratio", position, duration).set_trans(Tween.TRANS_SINE)
