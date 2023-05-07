extends Node

var events_collection : PocketbaseCollection

func _ready():
	events_collection = Pocketbase.collection('events')
	DialogueManager.title_passed.connect(_on_title_passed)

func add(type: String, action: String, info: String = '') -> void:
	print('EVENT! %s (%s): %s' % [type,action,info])
#	TODO: add CSV fallback
	await events_collection.create({
		"type": type,
		"action": action,
		"info": info,
		"session": Session.session_id
	})

	
func _on_title_passed(title):
	print("Title: %s" % [title])
