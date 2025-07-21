extends Control
class_name Player_Inventory

@export var inventory: Inventory
@export var selection_box: TextureRect
@export var hotbar: TextureRect

@export var slots: Array[TextureRect]
@export var inventory_max_size: int = 8

var current_selected_box: int = 0
var selected_item: Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	update_hotbar()

func update_hotbar() -> void:
	if Input.is_action_just_released("mouse_wheel_up"):
		current_selected_box -= 1
	elif Input.is_action_just_released("mouse_wheel_down"):
		current_selected_box += 1
	
	if current_selected_box	< 0:
		current_selected_box = 7
	elif current_selected_box > 7:
		current_selected_box = 0
	
	selection_box.position.x = current_selected_box * 56
	
	for i in slots.size():
		var slot = slots[i]
		if i < inventory.items.size():
			var item = inventory.items[i]
			if item == null: continue
			slot.texture = item.icon_texture
		else:
			continue
		
	
	selected_item = inventory.items[current_selected_box]


func add_item(item: Item) -> bool:
	if inventory.items.size() <= inventory_max_size:
		var first_null_slot: int = -1
		for i in range(inventory.items.size()):
			var slot = inventory.items[i]
			if first_null_slot == -1 and slot == null:
				first_null_slot = i
				inventory.items[first_null_slot] = item
				return true
	return false
