extends Control

@onready var main_options = $MainOptions
@onready var multiplayer_options = $MultiplayerOptions

@onready var http_request_login = $HTTPRequest

@onready var username = $MultiplayerOptions/LoginOptions/Username
@onready var password = $MultiplayerOptions/LoginOptions/Password

func _ready():
	main_options.visible = true
	multiplayer_options.visible = false
	http_request_login.request_completed.connect(_on_request_completed)
	

func _on_singleplayer_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Terrain/testTerrain.tscn")


func _on_multiplayer_button_pressed():
	main_options.visible = false
	multiplayer_options.visible = true


func _on_back_pressed():
	_ready()


func _on_login_pressed():
	var headers = ["Content-Type: application/json"]
	var body = {
		"email": username.text,
		"password": password.text
	}
	http_request_login.request("http://127.0.0.1:8000/user/login/", headers, HTTPClient.METHOD_POST,JSON.stringify(body))

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(result, response_code, headers)
	print(json)
