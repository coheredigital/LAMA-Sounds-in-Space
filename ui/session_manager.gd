extends Panel

var sessions_collection : PocketbaseCollection

# Called when the node enters the scene tree for the first time.
func _ready():
	sessions_collection = Pocketbase.collection('sessions')
	var list = await sessions_collection.get_list(1,20)
	for item in list.get('items'):
		%SessionList.add_item("Session ID: %s   Study ID: %s   Age Group: %s   Run ID: %s" % [
			item.get("id"),
			item.get("study_id"),
			item.get("age_group"),
			item.get("run_id"),
		])
