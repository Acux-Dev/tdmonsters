extends Camera3D

var marker = preload("res://Scenes/test/marker.tscn")
var tower = preload("res://Scenes/Towers/SimpleTower/simple_tower.tscn")

var camera_distance := 0

signal spawn_tower_to_player

func _input(event):
	if event.is_action_pressed("click"):
		shoot_ray()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			#head.position.z = lerp(head.position.z, head.position.z+2, 0.2)
			if camera_distance < 40:
				translate(lerp(Vector3(), Vector3(0,0,2), 0.2))
				camera_distance += 2
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			#head.position.z = lerp(head.position.z, head.position.z-2, 0.2)
			if camera_distance > 0:
				translate(lerp(Vector3(), Vector3(0,0,-2), 0.2))
				camera_distance -= 2
	
	if camera_distance == 0:
		GameManager.mouseCapture()
	else:
		GameManager.mouseVisible()

func shoot_ray():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_lenght = 1000
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_lenght
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_results = space.intersect_ray(ray_query)
	print(raycast_results)
	spawn_tower_to_player.emit(tower, raycast_results)
