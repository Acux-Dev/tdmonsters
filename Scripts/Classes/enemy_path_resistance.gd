extends Resource
class_name PathEnemyResistance

enum resistance_types {
	PERCENTAGE,
	NUMBER
}

@export var resistance_type : resistance_types

@export_range(0, 100) var percentage_value : float = 0
@export var number_value : float = 0
