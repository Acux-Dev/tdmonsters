extends Node


func _ready():
	pass


func _process(delta):
	if OS.is_debug_build():
		if Input.is_action_pressed("debug_slowdown"):
			Engine.time_scale = 0.02
		else:
			Engine.time_scale = 1
		if Input.is_action_just_pressed("debug_reset"):
			get_tree().reload_current_scene()
