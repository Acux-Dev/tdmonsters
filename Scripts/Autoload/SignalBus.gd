extends Node

signal base_damaged(damage)

func base_reduce_health(damage):
	base_damaged.emit(damage)
