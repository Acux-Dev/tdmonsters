extends Resource
class_name ItemDetail

var label : String:
	set(value):
		if scene:
			if scene.has_method("get_label"):
				label = scene.get_label()
@export var scene : PackedScene
