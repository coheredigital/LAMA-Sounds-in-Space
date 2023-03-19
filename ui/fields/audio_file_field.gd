@tool
extends HBoxContainer

@onready var options = %AudioFileOptions



@export_dir var files_directory:
	set(value):
		files_directory = value
		update_options(files_directory)

		
		
func _ready():
	update_options(files_directory)

func update_options(directory):
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with('.wav'):
				print("Found file: " + file_name)
				if options:
					options.add_item(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
