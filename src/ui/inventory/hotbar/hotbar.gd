extends HBoxContainer

signal equip(item : Item)

var currently_equipped : Item:
	set(value):
		currently_equipped = value
		equip.emit(value)

var index = 0:
	set(value):
		index = value
		
		if index >= get_child_count():
			index = 0
		elif index < 0:
			index = get_child_count() -1
		
		currently_equipped = get_child(index).item
		
		var children = get_children() as Array[Button]
		for i in children:
			var tween = create_tween()
			if i == get_child(index):
				tween.tween_property(i, "offset_transform_position_ratio:y", -0.2, 0.1)
			else:
				tween.tween_property(i, "offset_transform_position_ratio:y", 0, 0.1)
		
		queue_redraw()

func _draw() -> void:
	#get_child(index).focus = true
	#draw_rect(Rect2(get_child(index).position, get_child(index).size), Color.WHITE, false, 1)
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			index -= 1
			print(index)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			index += 1
			print(index)

func update():
	pass

func use_current():
	pass
