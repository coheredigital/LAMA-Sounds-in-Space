extends Node

var events_collection : PocketbaseCollection

var csv_file : FileAccess

func _ready():
	events_collection = Pocketbase.collection('events')
	DialogueManager.title_passed.connect(_on_title_passed)
	Session.session_started.connect(create_csv)


func create_csv():
	var csv_file_name = "%s%s" % [Session.save_folder,'events.csv']
	csv_file = FileAccess.open(csv_file_name, FileAccess.WRITE)

	if csv_file:
		csv_file.store_csv_line(PackedStringArray(["time","type","action","info","session_id"]))
		csv_file.close()

func add(type: String, action: String, info: String = '') -> void:
	var csv_file_name = "%s%s" %[Session.save_folder,'events.csv']
	csv_file = FileAccess.open(csv_file_name, FileAccess.READ_WRITE)

	print('EVENT! %s (%s): %s' % [type,action,info])

#	var time = Time.get_datetime_dict_from_system()
	var unix_time = Time.get_unix_time_from_system()
#	var date = "%s%s%s" % [time['year'],time['month'],time['day']]

	if csv_file:
		csv_file.seek_end()
		csv_file.store_csv_line([unix_time,type,action,info,Session.session_id])
#		csv_file.store_line(",".join([unix_time,type,action,info,Session.session_id]))
	else:
		push_error("event.csv missing! (%s)" % csv_file_name)

	await events_collection.create({
		"type": type,
		"action": action,
		"info": info,
		"session": Session.pocketbase_id
	})
	if csv_file:
		csv_file.close()


func _on_title_passed(title):
	print("Title: %s" % [title])
