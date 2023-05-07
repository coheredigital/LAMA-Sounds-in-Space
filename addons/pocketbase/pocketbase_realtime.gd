extends Node
class_name PocketbaseCollection

signal reponse_received

var root_url := "http://127.0.0.1:8090"
var current_request : HTTPRequest
var current_response:
	set(value):
		current_response = value
		emit_signal('reponse_received')

var collection_name := "events":
	set(value):
		collection_name = value
		print("PockebaseCollection (name): %s" % [value])


func create(data: Dictionary):
	var request_url : String
	request_url = "%s/api/collections/%s/records" % [root_url, collection_name]
	print("Pocketbase (create) url: %s" % [request_url])
	print(data)
	var http = HTTPRequest.new()
	add_child(http)
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	http.request(request_url, headers, HTTPClient.METHOD_POST, json)
	await http.request_completed.connect(_on_request_completed)
	await self.reponse_received
	return current_response
	
	
func get_list(page: int, perPage: int, parameters: Dictionary = {}):
	
	var request_url : String
	request_url = "%s/api/collections/%s/records?page%s&perPage=%s" % [
		root_url, 
		collection_name, 
		page, 
		perPage
	]
	
	print("Pocketbase (get_list) url: %s" % [request_url])
	
	var http = HTTPRequest.new()
	add_child(http)
	
	var json = JSON.stringify(parameters)
	var headers = ["Content-Type: application/json"]
	http.request(request_url, headers, HTTPClient.METHOD_GET, json)
	await http.request_completed.connect(_on_request_completed)
	await self.reponse_received
	return current_response


func subscribe(name: String):
#	placeholder
	pass

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	current_response = json.get_data()



