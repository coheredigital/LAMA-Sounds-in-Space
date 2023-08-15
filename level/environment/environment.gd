@tool
extends WorldEnvironment

const SKY_SIZE = 64.0



@export var sky_gradient : Gradient 
@export var ground_color := Color.DARK_SLATE_GRAY : set = set_ground_color
@export var fog_color := Color.CADET_BLUE : set = set_fog_color
@export var horizon_color := Color.DARK_SALMON : set = set_horizon_color
@export_range(0.0,1.0) var horizon_height := 0.0 : 
	set(value):
		horizon_height = clamp(value, 0.0,1.0)
		var horizon_height_meters = value * -SKY_SIZE
		print(horizon_height_meters)
		
		if ground:
			ground.position.y = horizon_height_meters
		if sky_material:
			var sky_gradient_color : Color = sky_gradient.sample(horizon_height)
			sky_material.set_shader_parameter("horizon_height", -horizon_height)
			self.sky_color = sky_gradient_color
#			sky_material.set_shader_parameter("sky_color", sky_gradient_color)	
@export_range(0.0, 4.0, 0.1) var stars_brightness := 0.0 : 
	set(value):
		stars_brightness = value
		set_stars_brightness(value)
@onready var sky_material : ShaderMaterial  = %Sky.get_active_material(0)
@onready var ground := %Ground

var sky_color := Color.DARK_BLUE :
	set(value):
		sky_color = value
		environment.background_color = value
		if sky_material:
			sky_material.set_shader_parameter("sky_color", value)

func _ready():
	Sequencer.stars_brightness_changed.connect(set_stars_brightness)

func set_stars_brightness(value):
	if sky_material:
		var tween = create_tween()
		tween.tween_property(sky_material, "shader_parameter/stars_brightness", lerp(0.0,4.0,value), 1.0).set_trans(Tween.TRANS_SINE)

func set_ground_color(value):
	ground_color = value
	if sky_material:
		sky_material.set_shader_parameter("ground_color", lerp(ground_color, sky_color, abs(horizon_height) / SKY_SIZE))
#
func set_fog_color(value):
	fog_color = value
	environment.volumetric_fog_albedo = value
	environment.volumetric_fog_emission = value
	if sky_material:
		sky_material.set_shader_parameter("fog_color", lerp(fog_color, sky_color, abs(horizon_height) / SKY_SIZE))
#
func set_horizon_color(value):
	horizon_color = value
	if sky_material:
		sky_material.set_shader_parameter("horizon_color", lerp(horizon_color, sky_color, abs(horizon_height) / SKY_SIZE))

