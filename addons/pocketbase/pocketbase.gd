extends Node


var process_id := 0


func start_server():
	#	start the server
	var executable_directory := ProjectSettings.globalize_path("res://addons/pocketbase")
	var executable := "%s/pocketbase.exe" % executable_directory
	print(executable)
	var output : Array
	process_id = OS.create_process(executable, ['serve'])
	

	if process_id <= 0:
		print('Pocketbase: failed to start server')
		print(output)
		return []
	else:
		print('Pocketbase: process(%s) started' % [process_id])

func stop_server():
	if process_id > 0:
		print('Pocketbase: process(%s) stopped' % [process_id])
		OS.kill(process_id)

func collection(collection_name: String) -> PocketbaseCollection:
	var collection_scene := load("res://addons/pocketbase/pocketbase_collection.tscn")
	var collection : Node = collection_scene.instantiate()
	
	if collection:
		collection.collection_name = collection_name
	add_child(collection)
	
	return collection
