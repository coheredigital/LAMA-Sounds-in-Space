@tool
extends ColorRect

@onready var overlay_material := self.material

@export var active = false:
	set(value):
		active = value
		
		var tween_blur = create_tween()
		var tween_mix = create_tween()
		
		if not overlay_material:
			return
		
		if active:
			tween_blur.tween_property(overlay_material, "shader_parameter/blur_amount", 3.6, 3.0).set_trans(Tween.TRANS_EXPO)
			tween_mix.tween_property(overlay_material, "shader_parameter/mix_amount", 0.7, 3.0).set_trans(Tween.TRANS_EXPO)
		else:
			tween_blur.tween_property(overlay_material, "shader_parameter/blur_amount", 0.0, 3.0).set_trans(Tween.TRANS_EXPO)
			tween_mix.tween_property(overlay_material, "shader_parameter/mix_amount", 0.0, 3.0).set_trans(Tween.TRANS_EXPO)
#
