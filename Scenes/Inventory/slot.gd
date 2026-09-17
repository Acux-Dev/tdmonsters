extends Panel

enum SlotType {
	SHOP,
	HOTBAR
}

@export var slot_type: SlotType = SlotType.SHOP

@export var icon: TextureRect
@export var label: Label

@export var item: Item = null:
	set(value):
		item = value
		
		if value == null:
			icon.texture = null
			label.text = ""
			return
		
		icon.texture = value.icon


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
	
	if data.source_type == SlotType.HOTBAR:
		source_slot.item = previous_item


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
