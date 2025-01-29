extends Camera3D

var marker = preload("res://Scenes/test/marker.tscn")
var tower = preload("res://Scenes/Towers/SimpleTower/simple_tower.tscn")

signal spawn_tower_to_player

func _input(event):
	if event.is_action_pressed("click"):
		shoot_ray()

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
