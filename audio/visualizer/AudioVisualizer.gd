@tool
extends Node

@export var waveform : Curve
@export var gradient : Gradient
@export var definition := 16 setget set_definition # (int, 4, 32)
@export var min_frequency := 20.0 setget set_min_frequency # (float, 20.0, 22000.0, 10.0)
@export var max_frequency := 20000.0 setget set_max_frequency # (float, 20.0, 22000.0, 10.0)
@export var max_db = 0.0 setget set_max_db # (float, -40.0, 40.0, 0.1)
@export var min_db = -40.0 setget set_min_db # (float, -80.0, 0.0, 0.1)
@export var response_curve : Curve
@export var x_curve : Curve
@export var y_curve : Curve
@export var z_curve : Curve
@export var a_curve : Curve


var idx = AudioServer.get_bus_index("Analyze")
var spectrum : AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(idx, 0)

var histogram = []
var x_histogram = []
var y_histogram = []
var z_histogram = []
var a_histogram = []

var interval = 0.0


func set_min_frequency(value):
#	prevents min being set larger than max
	if value < max_frequency:
		min_frequency = value
		if response_curve:
			response_curve.min_value = value
			response_curve.set_point_value(0,value)
			response_curve.bake()

func set_max_frequency(value):
#	prevents max being set smaller than min
	if value > min_frequency:
		max_frequency= value
		if response_curve:
			response_curve.max_value = value
			response_curve.set_point_value(1,value)
			response_curve.bake()
			
			
func set_min_db(value):
#	prevents min being set larger than max
	if value < max_db:
		min_db = value


func set_max_db(value):
#	prevents max being set smaller than min
	if value > min_db:
		max_db = value


func set_definition(value):
	definition = value
#	if response_curve:
#		response_curve.bake_resolution = value
#		response_curve.bake()
	
	for i in range(definition):
		histogram.append(0)
		x_histogram.append(0)
		y_histogram.append(0)
		z_histogram.append(0)
		a_histogram.append(0)
	
	var gradient_offsets = []

	if gradient and value:
		print(value)
		for i in range(0, value):
			gradient_offsets.append( (i + 1.0) / definition)
		gradient.offsets = gradient_offsets

func _ready():
	set_definition(definition)

func _enter_tree():
	set_definition(definition)

	
	
func _process(delta):

	if not(spectrum):
		return

	var freq := min_frequency
	var interval := (max_frequency - min_frequency) / float(definition)
	var segment = 1.0 / float(definition)
	
	var offsets = {}

	for i in range(definition):
		
		var offset := i / float(definition)
		var freq_low = response_curve.interpolate_baked(offset - (segment * 0.25))
		var freq_high = response_curve.interpolate_baked(offset + (segment * 0.25))
		
		var mag = spectrum.get_magnitude_for_frequency_range(freq_low, freq_high)
		mag = linear_to_db(mag.length())
		mag = (mag - min_db) / (max_db - min_db)
		mag += 0.3 * (freq - min_frequency) / (max_frequency - min_frequency)
		mag = clamp(mag, 0.0, 1.0)

		var x_acceleration = x_curve.interpolate_baked(mag)
		var y_acceleration = y_curve.interpolate_baked(mag)
		var z_acceleration = z_curve.interpolate_baked(mag)
		var a_acceleration = a_curve.interpolate_baked(mag)
		
		var level_x = lerp(x_histogram[i], mag, x_acceleration * delta)
		var level_y = lerp(y_histogram[i], mag, y_acceleration * delta)
		var level_z = lerp(z_histogram[i], mag, z_acceleration * delta)
		var level_a = lerp(a_histogram[i], mag, a_acceleration * delta)
		
		histogram[i] = mag
		x_histogram[i] = level_x
		y_histogram[i] = level_y
		z_histogram[i] = level_z
		a_histogram[i] = level_a
		
		if gradient and gradient is Gradient:
			var color = Color(level_x,level_y,level_z,level_a)
			gradient.set_color(i,color)

