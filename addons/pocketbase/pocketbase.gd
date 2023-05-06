extends Node

var root_url := "http://127.0.0.1:8090"
var request_url := "http://127.0.0.1:8090"
var process_id := 0
var collection_name := "events":
	set(value):
		collection_name = value
		print("Pockebase Collection: %s" % [value])
		request_url = "%s/api/collections/%s/records" % [root_url, value]
		
@onready var http_request := HTTPRequest.new() 

func _ready():
#	start the server
	var executable_directory := ProjectSettings.globalize_path("res://addons/pocketbase")
	var executable := "%s/pocketbase.exe" % executable_directory
	print(executable)
	var output : Array
	
	process_id = OS.create_process(executable, ['serve'])
	

	if process_id <= 0:
		print('pocketbase: failed to start server')
		print(output)
		return []
	else:
		print('pocketbase: process(%s) started' % [process_id])

	add_child(http_request)
	self.collection_name = collection_name
	http_request.request_completed.connect(_on_request_completed)

func _exit_tree():
	OS.kill(process_id)

func collection(name: String) -> Node:
	self.collection_name = name
	return self

func create(data: Dictionary) -> void:
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http_request.request(request_url, headers, HTTPClient.METHOD_POST, json)
	print("HTTP Request: %s" % [request_url])
	print("HTTP Data: %s" % [json])

func _on_request_completed(result : int, response_code : int, headers, body : PackedByteArray ):
	print("HTTP Response: %s %s " % [result, response_code])
