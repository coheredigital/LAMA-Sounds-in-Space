@tool
extends WorldEnvironment

const SKY_SIZE = 64.0


@export var sky_color := Color.DARK_BLUE :
	set(value):
		sky_color = value
		environment.background_color = value
		if sky_material:
			sky_material.set_shader_parameter("sky_color", value)
@export var ground_color := Color.DARK_SLATE_GRAY : set = set_ground_color
@export var fog_color := Color.CADET_BLUE : set = set_fog_color
@export var horizon_color := Color.DARK_SALMON : set = set_horizon_color
@export_range(-64.0, 0.0) var horizon_height := 0.0 : 
	set(value):
		horizon_height = value
		if ground:
			ground.position.y = value
		if sky_material:
			sky_material.set_shader_parameter("horizon_height", value / SKY_SIZE)
			
			
@onready var sky_material : ShaderMaterial  = %Sky.get_active_material(0)
@onready var ground := %Ground

func _ready():
	Sequencer.stars_brightness_changed.connect(set_stars_brightness)

func set_stars_brightness(value):
	if sky_material:
		sky_material.set_shader_parameter("stars_brightness", value)

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

