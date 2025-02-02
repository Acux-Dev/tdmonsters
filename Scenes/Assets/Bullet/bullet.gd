extends CharacterBody3D

var target
var speed = 20
var bullet_damage

func _ready():
	look_at(Vector3(target.global_position.x, target.global_position.y, target.global_position.z))

func _physics_process(delta):
	if is_instance_valid(target):
		velocity = global_position.direction_to(target.global_position)*speed
		look_at(Vector3(target.global_position.x, target.global_position.y, target.global_position.z))
		
		move_and_slide()
	else:
		queue_free()

func _on_collision_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(bullet_damage)
		queue_free()
