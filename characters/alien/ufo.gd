@tool
extends Node3D


@onready var beam = $ufo/beam
@onready var beam_material = beam.get_active_material(0)
#@onready var beam_position_target = %BeamPostionTarget
@onready var beam_look_target = %BeamLookTarget
@export_range(1.0,8.0,0.1) var beam_speed := 2.0
@export var beam_active := false:
	set(value):
		beam_active = value
		var beam_length = 1.0 if value else 0.0
		if %BeamTransform3D:
			var scale_tween = create_tween()
			var alpha_tween = create_tween()
			if scale_tween and alpha_tween:
				scale_tween.tween_property(%BeamTransform3D, "scale", Vector3(lerp(0.75,1.0, beam_length),lerp(0.75,1.0, beam_length),lerp(0.1,1.0, beam_length)), 1.0).set_trans(Tween.TRANS_SINE)
				alpha_tween.tween_property(beam_material,"shader_parameter/alpha_amount",lerp(0.0,0.2,smoothstep(0.5,1.0,beam_length)), 1.0).set_trans(Tween.TRANS_SINE)

@export_range(0.0,1.0,0.1) var engine_sound := 0.0:
	set(value):
		engine_sound = value
		if %EngineSounds:
			%EngineSounds.pitch_scale = lerp(0.8,1.6,value)
			%EngineSounds.volume_db = lerp(-45.0,-35.0,value)
		
		
@onready var last_position =  self.global_transform.origin
var current_speed = 0.0

func _process(delta):
	
	var current_position =  self.global_transform.origin
	var distance = (last_position-current_position).length()
	last_position = current_position
	var target_speed = distance / delta if distance > 0.0 else 0.0
	current_speed = lerp(current_speed,target_speed,delta * 4.0)
	
	self.engine_sound = smoothstep(0.0,8.0,current_speed)
	
	last_position = self.global_transform.origin
	
	if beam:
		var look_transform : Transform3D = beam.global_transform
		look_transform = look_transform.looking_at(beam_look_target.global_transform.origin, Vector3( 0,0,1))
		beam.global_transform = beam.global_transform.interpolate_with(look_transform, delta * beam_speed)
		


func _on_visible_on_screen_notifier_3d_screen_entered():
	%EngineSounds.playing = true


func _on_visible_on_screen_notifier_3d_screen_exited():
	%EngineSounds.playing = false
