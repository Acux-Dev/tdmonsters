extends Button

enum SlotType {
	SHOP,
	HOTBAR
}

@export var slot_type: SlotType = SlotType.SHOP

@export var icon_texture: TextureRect
@export var label: Label

@export var item: Item = null:
	set(value):
		item = value
		
		if value == null:
			icon_texture.texture = null
			label.text = ""
			return
		
		icon_texture.texture = value.icon
		
		if value.details:
			if value.details.size() > 0 and value.details[0] !=  null:
				label.text = value.details[0].label


var was_dropped := false


func _can_drop_data(_at_position, data):
	if not ("item" in data):
		return false
	
	if not is_instance_of(data.item, Item):
		return false
	
	if data.source_slot == self:
		return false
	
	if slot_type == SlotType.SHOP:
		return false
	
	if slot_type == SlotType.HOTBAR:
		return true
	
	return false


func _drop_data(_at_position, data):
	was_dropped = true
	
	var source_slot = data.source_slot
	
	var previous_item = item
	
	item = data.item
	
	if data.source_type == SlotType.SHOP:
		_remove_item_from_hotbar(data.item)
	
	if data.source_type == SlotType.HOTBAR:
		source_slot.item = previous_item
	
	if get_parent().has_method("update"):
		get_parent().update()
	if data.source_slot.get_parent().has_method("update"):
		data.source_slot.get_parent().update()


func _get_drag_data(_at_position):
	if item == null:
		return null
	
	was_dropped = false
	
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = item.icon
	
	var texture_size = Vector2(16, 16)
	preview_texture.size = texture_size
	preview_texture.custom_maximum_size = texture_size
	preview_texture.set_stretch_mode(6)
	preview_texture.position = -(texture_size / 2)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	
	return {
		"item": item,
		"source_slot": self,
		"source_type": slot_type
	}


func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		if not was_dropped and slot_type == SlotType.HOTBAR:
			item = null


func _remove_item_from_hotbar(item_to_remove: Item):
	var parent = get_parent()
	
	for child in parent.get_children():
		if child == self:
			continue
		
		if child is Button and child.slot_type == SlotType.HOTBAR:
			if child.item == item_to_remove:
				child.item = null
				
				if child.get_parent().has_method("update"):
					child.get_parent().update()
				
				break


func _update_slots(source_slot):
	if get_parent().has_method("update"):
		get_parent().update()
	
	if source_slot.get_parent().has_method("update"):
		source_slot.get_parent().update()


func _on_mouse_entered() -> void:
	z_index += 1
	var tween = create_tween()
	tween.tween_property(self, "offset_transform_scale", Vector2(1.2, 1.2), 0.2)


func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "offset_transform_scale", Vector2(1, 1), 0.2)
	await tween.finished
	z_index -= 1
