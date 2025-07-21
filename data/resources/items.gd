extends Resource

class_name Item

enum Item_Type {
	CONSUMABLE,
	BLOCK
}

@export var name: String = ""
@export var icon_texture: Texture2D
@export var item_type: int
@export var stack_size: int = 16
@export var item_index: int
 
