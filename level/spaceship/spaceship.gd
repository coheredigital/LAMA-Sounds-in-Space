@tool
extends Node3D

var screen_state: String = "idle":
	set(value):
		screen_state = value
		update_screen(value)

@export var door_open := false : 
	set(value):
		door_open = value
		set_door_open(value)

@export var seatbelts_buckled := false : 
	set(value):
		seatbelts_buckled = value
		set_seatbelts_buckled(value)

@export var siren_active := false : 
	set(value):
		siren_active = value
		if %Siren:
			%Siren.active = siren_active

@export_range(0.0,1.0) var steering_motion := 0.0 : 
	set(value):
		steering_motion = value
		set_steering_motion(value)

@export_range(0.0,1.0) var flying_motion := 0.0 : 
	set(value):
		flying_motion = value
		set_flying_motion(value)

@export_range(0.0,1.0) var light_level := 0.0 : 
	set(value):
		light_level = value
		set_light_level(value)

var fuel_level := 1: 
	set(value):
		fuel_level = value
		set_fuel_level(value)

@onready var animation_tree := %AnimationTree
@onready var seatbelt_indicator := %seatbelt_indicator_left
@onready var seatbelt_indicator_material : ShaderMaterial = %seatbelt_indicator_left.get_active_material(0)

func _ready():
	Sequencer.screen_changed.connect(update_screen)
	Sequencer.door_open_changed.connect(set_door_open)
	Sequencer.steering_motion_changed.connect(set_steering_motion)
	Sequencer.flying_motion_changed.connect(set_flying_motion)
	Sequencer.stars_brightness_changed.connect(set_light_level)
	Sequencer.fuel_level_changed.connect(set_fuel_level)
	Sequencer.seatbelts_buckled_changed.connect(set_seatbelts_buckled)

func set_steering_motion(value: float) -> void:
	if animation_tree:
		var tween = create_tween()
		tween.tween_property(animation_tree, "parameters/steering_speed/scale", value, 1.0).set_trans(Tween.TRANS_SINE)
		tween.tween_property(animation_tree, "parameters/steering_blend/add_amount", smoothstep(0.0,0.01,value), lerp(3.0,0.1,smoothstep(0.0,0.1,value))).set_trans(Tween.TRANS_SINE)
		
func set_flying_motion(value: float) -> void:
	if animation_tree:
		var tween = create_tween()
		tween.tween_property(animation_tree, "parameters/flying_speed/scale", value, lerp(2.0,1.0,value)).set_trans(Tween.TRANS_SINE)
		tween.tween_property(animation_tree, "parameters/flying_blend/add_amount", smoothstep(0.0,0.01,value), lerp(2.0,1.0,value) ).set_trans(Tween.TRANS_SINE)


func set_light_level(value: float) -> void:
	if not %Light:
		return
		
	var tween = create_tween()
	if not tween:
		return
		
	tween.tween_property(%Light, "light_energy", lerp(0.01,0.3,value), 1.0 ).set_trans(Tween.TRANS_SINE)

func set_fuel_level(value: float) -> void:
	RenderingServer.global_shader_parameter_set("fuel_level", value)

func set_door_open(value: bool) -> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/door_state/playback")
		state_machine.travel( 'open' if value else 'close' ) 

func set_seatbelts_buckled(value: bool) -> void:
	if seatbelt_indicator_material:
		seatbelt_indicator_material.set_shader_parameter("frame_number", 2 if value else 1)

func update_screen(value: String)-> void:
	if animation_tree:
		var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/screen_state/playback")
		state_machine.travel(value)
