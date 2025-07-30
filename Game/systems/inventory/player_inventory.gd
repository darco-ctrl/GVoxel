extends Control
class_name Player_Inventory

@export var inventory: Inventory
@export var inventory_max_size: int = 8
@export var slots: Array[slot_node]
@export var selection_box: TextureRect

var current_selected_slot_index: int = 0
var selected_slot: Slot ## Currently selected inventory slot

func _ready() -> void:
	CommandManager.set_player_inventory(self)

func _process(delta: float) -> void:
	update_hotbar()
	update_inventory_slots()
	update_item_textures_in_inventory()

func update_hotbar() -> void:
	if Input.is_action_just_released("mouse_wheel_up"):
		current_selected_slot_index -= 1
	elif Input.is_action_just_released("mouse_wheel_down"):
		current_selected_slot_index += 1
	
	if current_selected_slot_index < 0:
		current_selected_slot_index = 7
	elif current_selected_slot_index > 7:
		current_selected_slot_index = 0
	
	if selection_box.current_slot_index != current_selected_slot_index:
		if current_selected_slot_index < slots.size():
			selection_box.reparent(slots[current_selected_slot_index], false)
			selection_box.current_slot_index = current_selected_slot_index

func update_item_textures_in_inventory()-> void:
	for i in slots.size():
		var current_slot_node = slots[i] as slot_node
		var stot_texture: TextureRect = current_slot_node.item_texture_node
		if i < inventory.slots.size():
			
			var slot = inventory.slots[i] as Slot
			if slot == null: continue
			
			var item = slot.item
			if item == null: continue
			
			stot_texture.texture = item.icon_texture
				
		else:
			continue
	

func update_inventory_slots() -> void:
	var current_slote_data: Slot = inventory.slots[current_selected_slot_index]
	
	if current_slote_data:
		var current_panel_node = slots[current_selected_slot_index]
		if current_slote_data.item_count <= 0 and current_panel_node:
			inventory.slots[current_selected_slot_index] = null
			current_panel_node.item_texture_node.texture = null
			
			
		
		selected_slot = inventory.slots[current_selected_slot_index]

func add_item(item: Item, item_count:int = 1) -> bool:
	var first_null_slot: int = -1 
	for slot in range(inventory.slots.size()):
		var current_slot: Slot = inventory.slots[slot]
		var display_slot: slot_node = slots[slot]
		
		if first_null_slot == -1 and current_slot == null:
			first_null_slot = slot
		
		# creating new slot
		if current_slot != null:
			var current_item = current_slot.item
			if item == current_item:
				current_slot.item_count += item_count
				
				display_slot.slot_data = current_slot
				
				return true
	
	if first_null_slot != -1:
		var current_slot: Slot = inventory.slots[first_null_slot]
		var display_slot: slot_node = slots[first_null_slot]
		
		if !current_slot:
			var new_slot: Slot = Slot.new()
			new_slot.item = item
			new_slot.item_count += item_count
			inventory.slots[first_null_slot] = new_slot
			
			display_slot.slot_data = new_slot
		
			return true
	
	return false


#func clear_inventory()

#func add_item(item: Item) -> bool:
	#if inventory.items.size() <= inventory_max_size:
	#	var first_null_slot: int = -1
	#	for i in range(inventory.items.size()):
	#		var slot = inventory.items[i]
	#		if first_null_slot == -1 and slot == null:
	#			first_null_slot = i
	#			inventory.items[first_null_slot] = item
	#			return true
	#return false
