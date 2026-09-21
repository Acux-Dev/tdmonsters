extends Node3D

@export var turn_at_items : Array[Node3D]
@export var look_at_items : Array[Node3D]
@export var offset : bool

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func loot_at_target(target_location: Vector3):
	for i in turn_at_items:
		i.look_at(Vector3(target_location.x, i.position.y, target_location.z))
	for i in look_at_items:
		i.look_at(target_location)
