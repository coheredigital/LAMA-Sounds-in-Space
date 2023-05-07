extends Node

var events_collection : PocketbaseCollection

func _ready():
	events_collection = Pocketbase.collection('events')


func add(type: String, action: String, info: String = '') -> void:
	print('EVENT! %s (%s): %s' % [type,action,info])
#	TODO: add CSV fallback
	await events_collection.create({
		"type": type,
		"action": action,
		"info": info,
		"session": Session.session_id
	})
