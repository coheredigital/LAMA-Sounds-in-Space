# Directly adapted from the "example_balloon" provided by the Dialogue Manager addon
extends Panel

@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label := %DialogueLabel
@onready var responses_menu: VBoxContainer = %Responses
@onready var response_template: RichTextLabel = %ResponseTemplate

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = true

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
#		is_waiting_for_input = false

		if not next_dialogue_line:
			queue_free()
			return
		
		# Remove any previous responses
		for child in responses_menu.get_children():
			responses_menu.remove_child(child)
			child.queue_free()
		
		dialogue_line = next_dialogue_line
		
		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = tr(dialogue_line.character, "dialogue")
		
		dialogue_label.modulate.a = 0
#		dialogue_label.custom_minimum_size.x = dialogue_label.get_parent().size.x - 1
		dialogue_label.dialogue_line = dialogue_line

		# Show any responses we have
		responses_menu.modulate.a = 0
		if dialogue_line.responses.size() > 0:
			for response in dialogue_line.responses:
				# Duplicate the template so we can grab the fonts, sizing, etc
				var item: RichTextLabel = response_template.duplicate(0)
				item.name = "Response%d" % responses_menu.get_child_count()
				if not response.is_allowed:
					item.name = String(item.name) + "Disallowed"
					item.modulate.a = 0.4
				item.text = response.text
				item.show()
				responses_menu.add_child(item)
		
		dialogue_label.modulate.a = 1
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing
		
		# Wait for input
		if dialogue_line.responses.size() > 0:
			responses_menu.modulate.a = 1
		elif dialogue_line.time != null:
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			
			grab_focus()
	get:
		return dialogue_line


func _ready():
	focus_mode = Control.FOCUS_ALL
	var resource = load("res://dialogue/script.dialogue")
	start(resource, "load")
	response_template.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)




## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states = extra_game_states
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Helpers




# Get a list of enabled items
func get_responses() -> Array:
	var items: Array = []
	for child in responses_menu.get_children():
		if "Disallowed" in child.name: continue
		items.append(child)
		
	return items




### Signals
func _on_mutated(mutation: Dictionary) -> void:
	is_waiting_for_input = false





func _on_gui_input(event: InputEvent) -> void:
	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return
	# When there are no response options the balloon itself is the clickable thing	
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.next_id)
#	elif event.is_action_pressed("ui_accept") and get_viewport().gui_get_focus_owner() == balloon:
	elif event.is_action_pressed("ui_accept"):
		next(dialogue_line.next_id)


func _on_responses_gui_input(event: InputEvent, item: Control) -> void:
	if "Disallowed" in item.name: return
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		next(dialogue_line.responses[item.get_index()].next_id)
	elif event.is_action_pressed("ui_accept") and item in get_responses():
		next(dialogue_line.responses[item.get_index()].next_id)


func _on_mouse_entered(item: Control) -> void:
	if "Disallowed" in item.name: return
	grab_focus()
