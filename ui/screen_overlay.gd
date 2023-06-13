@tool
extends ColorRect

@onready var overlay_material := self.material
@onready var logo := %Logo

@export var active = true:
	set(value):
		active = value
		
		var tween = create_tween()
		var tween_logo = create_tween()
		
		if not overlay_material:
			return
		
		if active:
			tween.parallel().tween_property(overlay_material, "shader_parameter/blur_amount", 3.6, 3.0).set_trans(Tween.TRANS_SINE)
			tween.parallel().tween_property(overlay_material, "shader_parameter/mix_amount", 0.7, 3.0).set_trans(Tween.TRANS_SINE)
			tween_logo.tween_interval(1.5)
			tween_logo.tween_property(logo, "modulate:a",  1.0 if logo_active else 0.0, 1.0).set_trans(Tween.TRANS_SINE)
		else:
			tween_logo.tween_property(logo, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
			tween.parallel().tween_property(overlay_material, "shader_parameter/blur_amount", 0.0, 3.0).set_trans(Tween.TRANS_SINE)
			tween.parallel().tween_property(overlay_material, "shader_parameter/mix_amount", 0.0, 3.0).set_trans(Tween.TRANS_SINE)
			


@export var logo_active = true:
	set(value):
		logo_active = value
		
#		var tween = create_tween()
#
#		if logo_active:
#			tween.tween_property(logo, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
#		else:
#			tween.tween_property(logo, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE)


func _ready():
	Sequencer.overlay_toggled.connect(toggle_state)
	
func toggle_state(state:bool) -> void:
	self.active = state
