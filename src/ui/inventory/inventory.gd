extends Control

var current_scene

@export var grid_container: GridContainer
@export var hotbar: HBoxContainer

var slot_scene = preload("res://src/ui/inventory/slot/slot.tscn")
@export var available_items: Array[Item]

@export var towers_container: Container

func _ready() -> void:
	for item in available_items:
		var new_item = slot_scene.instantiate()
		new_item.item = item
		towers_container.add_child(new_item)
		

func _on_hotbar_equip(item: Item) -> void:
	if current_scene != null:
		current_scene.currently_equipped = item

func use_item():
	hotbar.uptade()
	hotbar.use_current()
