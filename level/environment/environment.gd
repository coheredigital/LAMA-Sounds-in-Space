@tool
extends WorldEnvironment

const SKY_SIZE = 128.0
const FOG_DENSITY_FACTOR = 0.25
const WORLD_LIGHT_MAX = 0.2
const WORLD_LIGHT_MIN = 0.01
const PLANET_DISTANCE_MIN := 0.23

signal star_distance_changed(value:float)

@export var sky_gradient : Gradient = preload("res://level/environment/gradients/sky_color_gradient.tres")
@export var ground_color := Color.DARK_SLATE_GRAY : set = set_ground_color
@export var fog_color := Color.CADET_BLUE : set = set_fog_color
@export var fog_density_curve : Curve
@export var horizon_color := Color.DARK_SALMON : set = set_horizon_color

@export_range(0.0,1.0) var altitude := 0.0 : 
	set(value):
		altitude = clamp(value, 0.0,1.0)
#		use linear value adjusted by curve to get more natural result
		if not altitude_curve:
			return
		var altitude_adjusted := altitude * altitude_curve.sample_baked(altitude)
		
		var horizon_height_meters := altitude_adjusted * -SKY_SIZE
		
		if ground:
			ground.position.y = horizon_height_meters
		if sky_material:
			var sky_gradient_color : Color = sky_gradient.sample(altitude_adjusted)
			sky_material.set_shader_parameter("horizon_height", -altitude_adjusted)
			self.sky_color = sky_gradient_color
		if world_light:
			world_light.light_energy = lerp(WORLD_LIGHT_MIN,WORLD_LIGHT_MAX, world_light_curve.sample_baked(altitude) )
			
@export var altitude_curve : Curve = preload("res://level/environment/curves/altitude_curve.tres")
@export var world_light_curve : Curve = preload("res://level/environment/curves/world_light_curve.tres")

var planet_scale := 0.0 : 
	set(value):
		planet_scale = clamp(value, 0.0,1.0)
#		use linear value adjusted by curve to get more natural result
		if not planet_scale_curve:
			return
		var planet_scale_adjusted := planet_scale_curve.sample_baked(planet_scale)
		if planet:
			planet.scale = Vector3(planet_scale_adjusted,planet_scale_adjusted,planet_scale_adjusted)
			
@export var planet_scale_curve : Curve = preload("res://level/environment/curves/planet_scale_curve.tres")

@export_range(0.0,1.0) var planet_distance := 0.0 : 
	set(value):
		planet_distance = clamp(value, 0.0,1.0)
		self.planet_scale = 1.0 - planet_distance
#		use linear value adjusted by curve to get more natural result
		if not planet_distance_curve:
			return
		var planet_distance_adjusted := planet_distance_curve.sample_baked(planet_distance)
		if planet_height_curve:
			self.planet_height = planet_height_curve.sample_baked(planet_distance)
		if planet:
			planet.position.z = -(SKY_SIZE * 0.5) * planet_distance_adjusted
			
@export var planet_distance_curve : Curve = preload("res://level/environment/curves/planet_distance_curve.tres")

var planet_height := 1.0 : 
	set(value):
		planet_height = clamp(value, 0.0,1.0)
#		use linear value adjusted by curve to get more natural result
		if planet_pivot:
			planet_pivot.rotation_degrees.x = lerp(-90.0,30.0,planet_height)
		if planet:
			planet.rotation_degrees.x = lerp(-90.0,30.0,planet_height)
			
@export var planet_height_curve : Curve = preload("res://level/environment/curves/planet_height_curve.tres")

@export_range(0.0,1.0, 0.01) var stars_progress := 1.0 : 
	set(value):
		stars_progress = clamp(value, 0.0,1.0)
#		if stars_angle_curve:
#			self.stars_angle = stars_angle_curve.sample_baked(stars_progress)
		if stars_distance_curve:
			self.stars_distance = stars_distance_curve.sample_baked(stars_progress)
		if stars_height_curve:
			self.stars_height = stars_height_curve.sample_baked(stars_progress)

#var stars_angle := 1.0 : 
#	set(value):
#		stars_angle = clamp(value, 0.0,1.0)
#		if stars:
#			stars.rotation_degrees.x = lerp(90.0,0.0,stars_angle)
#@export var stars_angle_curve : Curve = preload("res://level/environment/curves/stars_angle_curve.tres")

var stars_height := 1.0 : 
	set(value):
		stars_height = clamp(value, -1.0,1.0)
		if stars:
			stars.position.y = stars_height * SKY_SIZE
@export var stars_height_curve : Curve = preload("res://level/environment/curves/stars_height_curve.tres")
var stars_distance := 0.0 : 
	set(value):
		stars_distance = clamp(value, -1.0,1.0)
		if stars:
			stars.position.z = stars_distance * -SKY_SIZE
@export var stars_distance_curve : Curve = preload("res://level/environment/curves/stars_distance_curve.tres")
@export_range(0.0, 4.0, 0.1) var stars_brightness := 0.0 : 
	set(value):
		stars_brightness = value
		set_stars_brightness(value)
		
@onready var sky_material : ShaderMaterial  = %Sky.get_active_material(0)
@onready var ground := %Ground
@onready var stars := %Stars
@onready var planet := %Planet
@onready var planet_material := preload("res://level/environment/materials/planet_material.tres")
@onready var planet_pivot := %PlanetPivot
@onready var world_light := %WorldLight


var sky_color := Color.DARK_BLUE :
	set(value):
		sky_color = value
		environment.background_color = value
		if sky_material:
			sky_material.set_shader_parameter("sky_color", value)

func _ready():
	Sequencer.altitude_changed.connect(set_altitude)
	Sequencer.planet_distance_changed.connect(set_planet_distance)
	Sequencer.planet_height_changed.connect(set_planet_height)
	Sequencer.planet_scale_changed.connect(set_planet_scale)
	Sequencer.stars_brightness_changed.connect(set_stars_brightness)

func set_altitude(value,duration):
	var tween = create_tween()
	tween.tween_property(self, "altitude", value, duration).set_trans(Tween.TRANS_SINE)
	
func set_planet_distance(value,duration):
	var tween = create_tween()
	tween.tween_property(self, "planet_distance", value, duration).set_trans(Tween.TRANS_SINE)
	
func set_planet_height(value,duration):
	var tween = create_tween()
	tween.tween_property(self, "planet_height", value, duration).set_trans(Tween.TRANS_SINE)
	
func set_planet_scale(value,duration):
	var tween = create_tween()
	tween.tween_property(self, "planet_scale", value, duration).set_trans(Tween.TRANS_SINE)

func set_stars_brightness(value):
	if sky_material:
		var tween = create_tween()
		tween.tween_property(sky_material, "shader_parameter/stars_brightness", lerp(0.0,4.0,value), 1.0).set_trans(Tween.TRANS_SINE)

func set_ground_color(value):
	ground_color = value
	if sky_material:
		sky_material.set_shader_parameter("ground_color", lerp(ground_color, sky_color, altitude))
#
func set_fog_color(value):
	fog_color = value
	environment.volumetric_fog_albedo = value
	environment.volumetric_fog_emission = value
	if sky_material:
		sky_material.set_shader_parameter("fog_color", lerp(fog_color, sky_color, altitude))
#
func set_horizon_color(value):
	horizon_color = value
	if sky_material:
		sky_material.set_shader_parameter("horizon_color", lerp(horizon_color, sky_color, altitude))

