extends MarginContainer


func _ready():
	Session.session_id_changed.connect(func(value): %SessionIDValue.text = value)
	Session.condition_id_changed.connect(func(value): %ConditionIDValue.text = value)
	Session.study_id_changed.connect(func(value): %StudyIDValue.text = value)
	Session.age_group_changed.connect(func(value): %AgeGroupValue.text = value)
	Session.run_id_changed.connect(func(value): %RunIDValue.text = value)
	Session.player_control_enabled.connect(func(value): %PlayerControlState.text = 'enabled' if value else 'disabled')
