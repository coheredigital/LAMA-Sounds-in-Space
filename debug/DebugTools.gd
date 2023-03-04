## @brief Single-file autoload for debug drawing and printing.
## Draw and print on screen from anywhere in a single line of code.
## Find it quickly by naming it "DDD".
extends Control

## @brief How many frames HUD text lines remain shown after being invoked.
const TEXT_LINGER_FRAMES = 5
## @brief How many frames lines remain shown after being drawn.
const LINES_LINGER_FRAMES = 1
## @brief Color of the text drawn as HUD
const TEXT_COLOR = Color.WHITE
## @brief Background color of the text drawn as HUD
const TEXT_BG_COLOR = Color(0.0, 0.0, 0.0, 0.5)
const DEFAULT_MATERIAL = preload("res://debug/debug_material.tres")

# 2D
var _canvas_item : CanvasItem = null
var _texts := {}
var _logs := {}
var _font: FontFile = preload("res://debug/font/overlay_font.tres")
var _debug_graph = preload("res://debug/scripts/debug_graph.gd")

# Graphs
@export var background_color := Color(0.0, 0.0, 0.0, 0.5)
@export var plot_graphs := true
@export var graph_color := Color.ORANGE
@export var normalize_units := true
@export var history := 100
@export var graph_height := 50
var _graphs := {}

# 3D
var _spatial_container
var _boxes := []
var _box_pool := []
var _box_mesh : Mesh = null
var _lines := []
var _line_material_pool := []


func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_spatial_container = Node3D.new()
	add_child(_spatial_container)

func set_visibility(state: bool):
	visible = state
	if _spatial_container:
		_spatial_container.visible = state


## @brief Draws the unshaded outline of a 3D box.
## @param position: world-space position of the center of the box
## @param size: size of the box in world units
## @param color
func draw_box(position: Vector3, size: Vector3, color: Color = Color.DARK_RED):
	var mi := _get_box()
#	var mat := _get_line_material()
	var mat := DEFAULT_MATERIAL.duplicate() as ShaderMaterial
	mat.set_shader_parameter("color",color)
	mi.material_override = mat
	mi.position = position
	mi.scale = size
	_boxes.append({
		"node": mi,
		"frame": Engine.get_frames_drawn() + LINES_LINGER_FRAMES
	})


## @brief Draws an unshaded 3D line.
## @param a: begin position in world units
## @param b: end position in world units
## @param color
func draw_line_3d(a: Vector3, b: Vector3, color: Color = Color.GREEN ):
	var g = ImmediateMesh.new()
	g.cast_shadow = false
	g.material_override = _get_line_material()
	g.begin(Mesh.PRIMITIVE_LINES)
	g.set_color(color)
	g.add_vertex(a)
	g.add_vertex(b)
	g.end()
	_spatial_container.add_child(g)
	_lines.append({
		"node": g,
		"frame": Engine.get_frames_drawn() + LINES_LINGER_FRAMES,
	})


## @brief Draws an unshaded 3D line defined as a ray.
## @param origin: begin position in world units
## @param direction
## @param length: length of the line in world units
## @param color
func draw_ray_3d(origin: Vector3, direction: Vector3, length : float = 1.0, color : Color = Color.BLUE):
	draw_line_3d(origin, origin + direction * length, color)


## @brief Adds a text monitoring line to the HUD, from the provided value.
## It will be shown as such: - {key}: {text}
## Multiple calls with the same `key` will override previous text.
## @param key: identifier of the line
## @param text: text to show next to the key
func set_text(key: String, value):
	_texts[key] = {
		"text": value if typeof(value) == TYPE_STRING else str(value),
		"frame": Engine.get_frames_drawn() + TEXT_LINGER_FRAMES
	}

func log_text(value):
	var log_time = OS.get_system_time_msecs()
	_logs[log_time] = {
		"text": value if typeof(value) == TYPE_STRING else str(value),
		"frame": Engine.get_frames_drawn() + TEXT_LINGER_FRAMES
	}

func _get_box() -> MeshInstance3D:
	var mi : MeshInstance3D
	if len(_box_pool) == 0:
		mi = MeshInstance3D.new()
		if _box_mesh == null:
			_box_mesh = _create_wirecube_mesh(Color(1, 1, 1))
		mi.mesh = _box_mesh
		mi.cast_shadow = false
		_spatial_container.add_child(mi)
	else:
		mi = _box_pool[-1]
		_box_pool.pop_back()
		mi.cast_shadow = false
	return mi


func _recycle_box(mi: MeshInstance3D):
	mi.hide()
	_box_pool.append(mi)


func _get_line_material() -> StandardMaterial3D:
	var mat : StandardMaterial3D
	if len(_line_material_pool) == 0:
		mat = StandardMaterial3D.new()
		mat.flags_unshaded = true
		mat.vertex_color_use_as_albedo = true
	else:
		mat = _line_material_pool[-1]
		_line_material_pool.pop_back()
	return mat


func _recycle_line_material(mat: StandardMaterial3D):
	_line_material_pool.append(mat)


func _process_3d_lines_delayed_free(items: Array):
	var i := 0
	while i < len(items):
		var d = items[i]
		if d.frame <= Engine.get_frames_drawn():
			_recycle_line_material(d.node.material_override)
			d.node.queue_free()
			items[i] = items[i - 1]
			items.pop_back()
		else:
			i += 1


func _process(_delta: float):

#	update graphs
	for name in _graphs.keys():
		var item = _graphs[name]
		item.update()

	_process_3d_lines_delayed_free(_lines)
	_process_3d_lines_delayed_free(_boxes)

	# Progressively delete boxes
	if len(_box_pool) > 0:
		var last = _box_pool[-1]
		_box_pool.pop_back()
		last.queue_free()

	# Remove text lines after some time
	for key in _texts.keys():
		var t = _texts[key]
		if t.frame <= Engine.get_frames_drawn():
			_texts.erase(key)

	# Update canvas
	if _canvas_item == null:
		_canvas_item = Node2D.new()
		_canvas_item.position = Vector2(8, 8)
		_canvas_item.z_index = 100
		_canvas_item.connect("draw",Callable(self,"_on_CanvasItem_draw"))
		add_child(_canvas_item)
	_canvas_item.update()


func _on_CanvasItem_draw():
	var ci := _canvas_item

	var ascent := Vector2(0, _font.get_ascent())
	var pos := Vector2()
	var xpad := 2
	var ypad := 1
	var font_offset := ascent + Vector2(xpad, ypad)
	var line_height := _font.get_height() + 2 * ypad

	for key in _texts.keys():
		var t = _texts[key]
		var text := str(key, ": ", t.text, "\n")
		var ss := _font.get_string_size(text)
		ci.draw_rect(Rect2(pos, Vector2(ss.x + xpad * 2, line_height)), TEXT_BG_COLOR)
		ci.draw_string(_font, pos + font_offset, text, TEXT_COLOR)
		pos.y += line_height


static func _create_wirecube_mesh(color := Color.WHITE) -> ArrayMesh:
	var positions := PackedVector3Array([
		Vector3(0, 0, 0),
		Vector3(1, 0, 0),
		Vector3(1, 0, 1),
		Vector3(0, 0, 1),
		Vector3(0, 1, 0),
		Vector3(1, 1, 0),
		Vector3(1, 1, 1),
		Vector3(0, 1, 1)
	])
	var colors := PackedColorArray([
		color, color, color, color,
		color, color, color, color,
	])
	var indices := PackedInt32Array([
		0, 1,
		1, 2,
		2, 3,
		3, 0,

		4, 5,
		5, 6,
		6, 7,
		7, 4,

		0, 4,
		1, 5,
		2, 6,
		3, 7
	])
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = positions
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	return mesh


func clear_graphs() -> void:
	for graph in _graphs:
		graph.queue_free()
	_graphs = {}


func graph(name: String, monitor: int, unit: String = "") -> void:

	if name in _graphs.keys():
		return

	var graph = _debug_graph.new()
	graph.monitor = monitor
	graph.monitor_name = name
	graph.font = _font
	graph.custom_minimum_size.y = graph_height
	graph.max_points = history
	graph.background_color = background_color
	graph.graph_color = graph_color
	graph.plot_graph = plot_graphs
	graph.unit = unit
	graph.normalize_units = normalize_units

	add_child(graph)
	_graphs[name] = graph
