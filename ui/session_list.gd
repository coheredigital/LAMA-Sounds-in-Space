extends ItemList

var collection : PocketbaseCollection
var list : Array
var items : Array

func _ready():
	collection = Pocketbase.collection('sessions')
	update_list()


func get_list() -> Array:
	var directories = DirAccess.get_directories_at(Session.root_directory)
	
	return  DirAccess.get_directories_at(Session.root_directory)


func update_list() -> void:
	clear()
#	list = await collection.get_list(1,100, {
#		"sort": "-created"
#	})
#	items = list.get('items')
	
	items = get_list()
	print(items)
	for item in items:
		print(item)		
		add(item)



func add(item: String):
	
#	get session info
	var info_file = "%s%s/%s" % [Session.root_directory, item, 'info.json']
	
	var session_directory = DirAccess.open("%s%s" % [Session.root_directory, item])
	
	if session_directory.file_exists(info_file):
		info_file = FileAccess.open(info_file, FileAccess.READ)
		var info_json = JSON.parse_string(info_file.get_as_text())
		print(info_json)
#		add_item(info_json)
#
	
		add_item("Datetime: %s   Study ID: %s   Age Group: %s   Run ID: %s" % [
			info_json.get("create_datetime"),
			info_json.get("study_id"),
			info_json.get("age_group"),
			info_json.get("run_id"),
		])


func _on_item_activated(index):
#	var list_item = list.index(index)
	var item = items[index]
	var folder = "%s%s" % [Session.root_directory,item]
	folder = ProjectSettings.globalize_path(folder)
	print("OPEN: %s" % [folder])
	OS.shell_open(folder)
