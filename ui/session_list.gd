extends ItemList

var collection : PocketbaseCollection
var list : Dictionary
var items : Array

func _ready():
	collection = Pocketbase.collection('sessions')
	
	list = await collection.get_list(1,100, {
		"sort": "-created"
	})
	items = list.get('items')
	
	for item in items:
		%SessionList.add_item("Session ID: %s   Study ID: %s   Age Group: %s   Run ID: %s" % [
			item.get("id"),
			item.get("study_id"),
			item.get("age_group"),
			item.get("run_id"),
		])


func _on_item_activated(index):
#	var list_item = list.index(index)
	var item = items[index]
	var folder = "user://sessions/%s" % [item.get('id')]
	folder = ProjectSettings.globalize_path(folder)
	print("OPEN: %s" % [folder])
	OS.shell_open(folder)
