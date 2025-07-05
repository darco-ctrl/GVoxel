extends TextureRect

@export var selection_box: TextureRect

var inventory: Array = [ItemData.Dirt, ItemData.Grass, ItemData.Stone, ItemData.Air, ItemData.Air, ItemData.Air, ItemData.Air, ItemData.Air]
var current_slot: int = 0
var inventory_size: int = 8
var selected_item: Object

func _ready() -> void:
	selected_item = inventory[0]

func _process(delta: float) -> void:
	update_inventory_selection()
	
func update_inventory_selection() -> void:
	if Input.is_action_just_released("mouse_wheel_up"):
		current_slot += 1
		
	elif Input.is_action_just_released("mouse_wheel_down"):
		current_slot -= 1
	
	current_slot = clampi(current_slot, 0, 7)
	
	var new_selection_box_position = (current_slot * 34) + 1
	selection_box.position.x = new_selection_box_position
	
	selected_item = inventory[current_slot]


	
