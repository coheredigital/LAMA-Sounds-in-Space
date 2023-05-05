extends Node

@export var waveform : Curve
@export var gradient : Gradient
@export_range (4, 32) var definition := 16: set = set_definition
@export_range(20.0, 22000.0, 10.0) var min_frequency := 20.0:
	set(value):
		min_frequency = value
		set_min_frequency(value) 
@export_range(20.0, 22000.0, 10.0) var max_frequency := 20000.0:
	set(value):
		max_frequency = value
		set_max_frequency(value)
@export_range(-40.0, 40.0, 0.1) var max_db := 0.0:
	set(value):
		if value >= min_db:
			max_db = value
@export_range(-80.0, 0.0, 0.1) var min_db := -40.0:
	set(value):
		if value <= max_db:
			min_db = value
@export var response_curve : Curve
@export var x_curve : Curve
@export var y_curve : Curve
@export var z_curve : Curve
@export var a_curve : Curve


var idx = AudioServer.get_bus_index("Analyze")
var spectrum : AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(idx, 0)

var histogram := []
var x_histogram := []
var y_histogram := []
var z_histogram := []
var a_histogram := []

var interval := 0.0


func set_min_frequency(value):
#	prevents min being set larger than max
	if value < max_frequency:
		if response_curve:
			response_curve.min_value = value
			response_curve.set_point_value(0,value)
			response_curve.bake()

func set_max_frequency(value):
#	prevents max being set smaller than min
	if value > min_frequency:
		if response_curve:
			response_curve.max_value = value
			response_curve.set_point_value(1,value)
			response_curve.bake()


func set_definition(value):
	definition = value
#	if response_curve:
#		response_curve.bake_resolution = value
#		response_curve.bake()
	
	for i in range(definition):
		histogram.append(0.0)
		x_histogram.append(0.0)
		y_histogram.append(0.0)
		z_histogram.append(0.0)
		a_histogram.append(0.0)
	
	var gradient_offsets = []

	if gradient and value:
		print(value)
		for i in range(0, value):
			gradient_offsets.append( (i + 1.0) / definition)
		gradient.offsets = gradient_offsets


func _ready():
#	ensure the audio analyzer is always running
	%AudioStreamRecord.playing = true
	set_definition(definition)

func _process(delta):

	if not(spectrum):
		return

	var segment = 1.0 / float(definition)
	var prev_hz = 0
	
	for i in range(definition):

		var offset := i / float(definition)
		var freq_low = response_curve.sample_baked(offset - (segment))
		var freq_high = response_curve.sample_baked(offset + (segment))
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(freq_low, freq_high).length()
		
#		convert to decibels
		var decibels := 0.0
		decibels = linear_to_db(magnitude)
		decibels = remap(decibels, min_db, max_db, 0.0, 1.0)
		decibels = clamp(decibels, 0.0, 1.0)
		
#		apply acceleration to each "axis/channel"
		var x_acceleration = x_curve.sample_baked(decibels)
		var y_acceleration = y_curve.sample_baked(decibels)
		var z_acceleration = z_curve.sample_baked(decibels)
		var a_acceleration = a_curve.sample_baked(decibels)
		var level_x = lerp(float(x_histogram[i]), decibels, x_acceleration * delta)
		var level_y = lerp(float(y_histogram[i]), decibels, y_acceleration * delta)
		var level_z = lerp(float(z_histogram[i]), decibels, z_acceleration * delta)
		var level_a = lerp(float(a_histogram[i]), decibels, a_acceleration * delta)

#		store each value in histogram arrays to facilitate interpolation
		histogram[i] = decibels
		x_histogram[i] = level_x
		y_histogram[i] = level_y
		z_histogram[i] = level_z
		a_histogram[i] = level_a

#		apply current value to Gradient resource
		if gradient and gradient is Gradient:
			var color = Color(level_x,level_y,level_z,level_a)
			gradient.set_color(i,color)
