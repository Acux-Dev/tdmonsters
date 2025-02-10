extends Sprite3D

var max_health
var health

var animation_speed = 0.1

func _ready():
	health = max_health
	$SubViewport/Panel/ProgressBar.max_value = max_health
	$SubViewport/Panel/ProgressBar.value = health

func _process(delta):
	pass

func take_damage(damage):
	health -= damage
	if health < 0:
		health = 0
	create_tween().tween_property($SubViewport/Panel/ProgressBar, "value", health, 0.1)
