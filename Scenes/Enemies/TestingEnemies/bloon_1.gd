extends CharacterBody3D

@export var enemy_stats : PathEnemyBase

@export var mesh : MeshInstance3D
@export var outline_material : Material
@export var selection_material : Material

var selected := false

@onready var Path : PathFollow3D = get_parent()

func _enter_tree():
	$EnemyInfo.max_health = enemy_stats.health

func _physics_process(delta):
	Path.set_progress(Path.get_progress() + enemy_stats.speed * delta)
	
	if Path.get_progress_ratio() >= 0.99:
		Path.queue_free()
	
	move_and_slide()

func take_damage(bullet_damage):
	enemy_stats.health -= bullet_damage
	$EnemyInfo.take_damage(bullet_damage)
	if enemy_stats.health <= 0:
		queue_free()

func _on_static_body_3d_mouse_entered():
	if not selected:
		mesh.material_overlay = outline_material

func _on_static_body_3d_mouse_exited():
	if not selected:
		mesh.material_overlay = null

func _on_static_body_3d_input_event(camera, event, event_position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !event.is_echo():
			selected = not selected
			if selected:
				mesh.material_overlay = selection_material
			else:
				mesh.material_overlay = outline_material


func _on_mouse_entered():
	$EnemyInfo.visible = true


func _on_mouse_exited():
	$EnemyInfo.visible = false
