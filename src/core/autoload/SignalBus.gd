extends Node

signal base_damaged(damage)
signal game_ended()
signal toast_notification(text : String, time : float)

func base_reduce_health(damage):
	base_damaged.emit(damage)

func emit_game_ended():
	game_ended.emit()

func show_toast_notification(text : String, time : float):
	toast_notification.emit(text, time)
