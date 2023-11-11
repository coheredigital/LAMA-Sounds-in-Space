extends Node

signal line_added(unix_time: float,type: String,action: String,info: String)
var csv_file : FileAccess

func _ready():
	Session.session_started.connect(create_csv)

func create_csv():
	var csv_file_name = "%s%s" % [Session.save_folder,'events.csv']
	csv_file = FileAccess.open(csv_file_name, FileAccess.WRITE)
	csv_file.store_csv_line(PackedStringArray(["time","type","action","info","session_id"]))
	csv_file.close()


func add(type: String, action: String, info: String = '') -> void:
	var csv_file_name = "%s%s" %[Session.save_folder,'events.csv']
	csv_file = FileAccess.open(csv_file_name, FileAccess.READ_WRITE)
	var unix_time = Time.get_unix_time_from_system()
	if csv_file:
		csv_file.seek_end()
		csv_file.store_csv_line([unix_time,type,action,info,Session.session_id])
		csv_file.close()
		line_added.emit(unix_time,type,action,info)


func _on_title_passed(title):
	print("Title: %s" % [title])
