@tool
extends ColorRect



@onready var overlay_material := self.material
@onready var logo := %Logo

@export_enum("hidden","logo","blackout") var state : String = "hidden":
	set(value):
		state = value
		var tween = create_tween()
		var tween_logo = create_tween()
		
		if not tween or not tween_logo:
			return
		
		match state:
			"hidden":
				tween_logo.tween_property(logo, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
				tween.parallel().tween_property(overlay_material, "shader_parameter/blur_amount", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
				tween.parallel().tween_property(overlay_material, "shader_parameter/mix_amount", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
			"logo":
				tween.parallel().tween_property(overlay_material, "shader_parameter/blur_amount", 3.6, 2.0).set_trans(Tween.TRANS_SINE)
				tween.parallel().tween_property(overlay_material, "shader_parameter/mix_amount", 0.7, 2.0).set_trans(Tween.TRANS_SINE)
				tween_logo.tween_interval(1.5)
				tween_logo.tween_property(logo, "modulate:a",  1.0, 1.0).set_trans(Tween.TRANS_SINE)
			"black":
				tween.parallel().tween_property(overlay_material, "shader_parameter/blur_amount", 6.0, 2.0).set_trans(Tween.TRANS_SINE)
				tween.parallel().tween_property(overlay_material, "shader_parameter/mix_amount", 1.0, 2.0).set_trans(Tween.TRANS_SINE)
				tween_logo.tween_interval(1.5)
				tween_logo.tween_property(logo, "modulate:a",  0.0, 1.0).set_trans(Tween.TRANS_SINE)
				


func _ready():
	Sequencer.overlay_state_changed.connect(set_state)
	
func set_state(state:String) -> void:
	self.state = state
