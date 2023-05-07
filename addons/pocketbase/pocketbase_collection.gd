class_name PocketbaseRealtime
extends Node

# The URL we will connect to
@export var websocket_url = "http://127.0.0.1:8090/"

# Our WebSocketClient instance
var socket = WebSocketPeer.new()


func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	socket.connection_closed.connect(_closed)
	socket.connection_error.connect(_closed)
	socket.connection_established.connect(_connected)


func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	print("Got data from server: ", socket.get_peer(1).get_packet().get_string_from_utf8())

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, 
	# and signals emission will only happen when calling this function.
	socket.poll()
