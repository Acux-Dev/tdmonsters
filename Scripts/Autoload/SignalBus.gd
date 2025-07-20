extends Node

signal base_damaged(damage)
signal game_ended()

func base_reduce_health(damage):
	base_damaged.emit(damage)

func emit_game_ended():
	game_ended.emit()
