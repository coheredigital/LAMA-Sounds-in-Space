extends CodeEdit



func _ready():
#	clear any existing text
	text = ""
	EventLogger.line_added.connect(_on_event_logger_line_added)
	
func _on_event_logger_line_added(unix_time: float,type: String,action: String,info: String):
	var time_formatted = Time.get_datetime_dict_from_unix_time(unix_time-Session.start_time)
	var time_string = "%02d:%02d" % [time_formatted.minute,time_formatted.second]
	add_line(time_string,type,action,info)	
	
func add_line(time_string: String,type: String,action: String,info: String):
	var line_count := get_line_count()
	if text != "":
		text = text + "\n"
		
	var type_action_string := "%s.%s" % [type,action]
	text = text + "%-8s%-24s\"%s\"" % [time_string,type_action_string,info]
	set_caret_line(line_count)


func _on_log_toggle_toggled(button_pressed):
	visible = button_pressed
