extends CharacterBody3D

@export var speed = 2
@export var health = 10

@onready var Path : PathFollow3D = get_parent()

func _physics_process(delta):
	Path.set_progress(Path.get_progress() + speed * delta)
	
	if Path.get_progress_ratio() >= 0.99:
		Path.queue_free()
	
	move_and_slide()

func take_damage(bullet_damage):
	health -= bullet_damage
	if health <= 0:
		queue_free()
