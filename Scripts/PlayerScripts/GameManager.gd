extends Node

var mouse_captured := false
var building_mode := false

func _ready():
	pass

func _input(event):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("debug_slowdown"):
			Engine.time_scale = 0.02
			print("slow down activado")
		if Input.is_action_just_released("debug_slowdown"):
			Engine.time_scale = 1
			print("slow down desactivado")
		if Input.is_action_just_pressed("debug_reset"):
			get_tree().reload_current_scene()

func _process(delta):
	pass

func mouseCapture():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func mouseVisible():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
