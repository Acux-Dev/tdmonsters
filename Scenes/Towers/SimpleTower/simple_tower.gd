@tool
extends StaticBody3D

var bullet = preload("res://Scenes/Assets/Bullet/bullet.tscn")
var bullet_damage = 5
var current_targets = []
var current_target
var can_shoot = true

func _process(delta):
	if is_instance_valid(current_target):
		$Tower.look_at(Vector3(current_target.global_position.x, 0, current_target.global_position.z))
		$Tower/TowerBody/RotationPoint.look_at(Vector3(current_target.global_position.x, current_target.global_position.y , current_target.global_position.z))
		if can_shoot:
			shoot()
			can_shoot = false
			$ShootingCooldown.start()
	else:
		for i in get_node("BulletContainer").get_child_count():
			get_node("BulletContainer").get_child(i).queue_free()

func shoot():
	current_target.take_damage(bullet_damage)
	#var temp_bullet = bullet.instantiate()
	#temp_bullet.rotation = Vector3($Tower/TowerBody/RotationPoint.rotation.x, $Tower/TowerBody.rotation.y, 0)
	#temp_bullet.target = current_target
	#temp_bullet.bullet_damage = bullet_damage
	#get_node("BulletContainer").add_child(temp_bullet)
	#temp_bullet.global_position = $Tower/TowerBody/RotationPoint/temp_front_look/AimingPoint.global_position

func choose_target(_current_targets):
	var temp_array = _current_targets
	var current_target_loop = null
	for i in temp_array:
		if current_target_loop == null:
			current_target_loop = i
		else:
			if i.get_parent().get_progress() > current_target_loop.get_parent().get_progress():
				current_target_loop = i
	current_target = current_target_loop

func _on_tower_range_body_entered(body):
	if body.is_in_group("Enemy"):
		print(body.name)
		current_targets.append(body)
		choose_target(current_targets)

func _on_tower_range_body_exited(body):
	if body.is_in_group("Enemy"):
		print(body.name)
		current_targets.erase(body)
		choose_target(current_targets)

func _on_shooting_cooldown_timeout():
	can_shoot = true


func _on_tower_area_mouse_entered():
	# makes visible the ranges of area of collision and range
	$TowerArea/TowerRangeCircle.visible = true
	$TowerRange/TowerRangeCircle.visible = true

func _on_tower_area_mouse_exited():
	# makes invisible the ranges of area of collision and range
	$TowerArea/TowerRangeCircle.visible = false
	$TowerRange/TowerRangeCircle.visible = false
