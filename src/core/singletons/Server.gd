extends Node

var peer = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 1909

func _ready():
	ConnectToServer()

func ConnectToServer():
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	multiplayer.set_multiplayer_peer(peer)
	#print("Connected to Server")
	
	multiplayer.connected_to_server.connect(_OnConnectionSucceded)
	multiplayer.server_disconnected.connect(_OnConnectionFailed)
	multiplayer.connection_failed.connect(_OnConnectionFailed)

func _OnConnectionFailed():
	print("Failed to connect")

func _OnConnectionSucceded():
	print("Succesfully connected")
