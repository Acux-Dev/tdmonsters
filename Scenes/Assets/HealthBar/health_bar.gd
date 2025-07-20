extends Control

var max_health := 100

var health

func _ready():
	health = max_health
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health
	$ProgressBar/HealthAmount.text = str(health) + "/" + str(max_health)
	SignalBus.base_damaged.connect(reduce_base_health)

func reduce_base_health(damage):
	health -= damage
	if health < 0:
		health = 0
	create_tween().tween_property($ProgressBar, "value", health, 0.1)
	$ProgressBar/HealthAmount.text = str(health) + "/" + str(max_health)
