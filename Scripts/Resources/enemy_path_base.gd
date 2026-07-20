class_name PathEnemyBase
extends Resource

@export_group("Info")
@export var name : String
@export_multiline var description : String

@export_group("Stats")
@export var health_overflow : int
@export var health : int
@export var shield : int
@export var speed : int

@export_group("Properties")
@export var resistance : PathEnemyResistance
@export var target_type : Array[visibility_types]
@export var property_type : Array[property_types]

enum visibility_types {
	GROUND,
	FLYING
}

enum property_types {
	EXPLOSIVE,
	GOO,
	FLESH
}
