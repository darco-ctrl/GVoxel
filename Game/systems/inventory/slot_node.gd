extends Panel
class_name slot_node

var slot_data: Slot = null
@export var item_texture_node: TextureRect
@export var item_count_display: Label

func _process(delta: float) -> void:
	if slot_data:
		item_count_display.text = str(slot_data.item_count)
	else:
		item_texture_node.texture = null
	
	if item_count_display.text == "0":
		item_count_display.text = " "
