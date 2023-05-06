extends Node
class_name PocketbaseCollection

var root_url := "http://127.0.0.1:8090"
var request_url : String
var collection_name := "events":
	set(value):
		collection_name = value
		print("PockebaseCollection (name): %s" % [value])
		request_url = "%s/api/collections/%s/records" % [root_url, value]

func _ready():
	add_child(%HTTPRequest)
	self.collection_name = collection_name

func create(data: Dictionary) -> void:
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	%HTTPRequest.request(request_url, headers, HTTPClient.METHOD_POST, json)
	print("HTTP Request: %s" % [request_url])
	print("HTTP Data: %s" % [json])


func _on_http_request_request_completed(result, response_code, headers, body):
	print("HTTP Response: %s %s " % [result, response_code])
