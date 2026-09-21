extends Resource
class_name Item

@export var title : String
@export var icon : Texture2D
var label : String:
	set(value):
		if details:
			label = details[0].label

@export var details : Array[ItemDetail]
