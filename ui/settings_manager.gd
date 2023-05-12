extends Panel

var tools_folder : String = "user://tools/"

var pocketbase_folder : String = "user://tools/pocketbase/"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_install_pocketbase_button_pressed():
	var url := "https://github.com/pocketbase/pocketbase/releases/download/v0.15.3/pocketbase_0.15.3_windows_amd64.zip"
	print("Install Pocketbase: %s" % url)
	DirAccess.make_dir_recursive_absolute(pocketbase_folder)
	download(url,pocketbase_folder)


func download(link, path):
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_http_request_completed)

	http.set_download_file(path)
	var request = http.request(link)
	if request != OK:
		push_error("Http request error")


func _http_request_completed(result, _response_code, _headers, _body):
	if result != OK:
		push_error("Download Failed")
	remove_child($HTTPRequest)
