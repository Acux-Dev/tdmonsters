extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		print(body)
		print(body.name)
		print(body.health)
		SignalBus.base_reduce_health(body.health)
		body.take_damage(body.health)
