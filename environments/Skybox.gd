@tool
extends WorldEnvironment

const SKY_SIZE = 64.0

@export var sky_color := Color.DARK_BLUE :
	set(value):
		sky_color = value
		set_sky_color(value)
@export var ground_color := Color.DARK_SLATE_GRAY : set = set_ground_color
@export var fog_color := Color.CADET_BLUE : set = set_fog_color
@export var horizon_color := Color.DARK_SALMON : set = set_horizon_color
@export_range(-64.0, 0.0) var horizon_height := 0.0 : set = set_horizon_height

@onready var ground = $Ground
@onready var ground_material : ShaderMaterial  = ground.get_active_material(0)
@onready var sky_material : ShaderMaterial = $Sky.get_active_material(0)


func set_sky_color(value):
	sky_color = value
	if !sky_material:
		return
	sky_material.set_shader_parameter("sky_color", value)
	environment.background_color = value
	

func set_ground_color(value):
	ground_color = value
	if !ground_material:
		return
	ground_material.set_shader_parameter("albedo", value)
	ground_material.set_shader_parameter("emission", value)
	sky_material.set_shader_parameter("ground_color", value)

func set_fog_color(value):
	fog_color = value
	if !sky_material:
		return
	environment.fog_color = value
	sky_material.set_shader_parameter("fog_color", value)


func set_horizon_color(value):
	horizon_color = value
	if !sky_material:
		return
	sky_material.set_shader_parameter("horizon_color", value)

func set_horizon_height(value):
	horizon_height = value
	if !sky_material:
		return
	sky_material.set_shader_parameter("horizon_height", value / SKY_SIZE)
	ground.position.y = value
