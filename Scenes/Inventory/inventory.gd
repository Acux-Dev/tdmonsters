extends Control

var current_scene

@export var grid_container: GridContainer
@export var hotbar: HBoxContainer


func _on_hotbar_equip(item: Item) -> void:
	if current_scene != null:
		current_scene.currently_equipped = item

func use_item():
	hotbar.uptade()
	hotbar.use_current()
