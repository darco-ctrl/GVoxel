extends Resource

class_name Item

@export var name: String = ""
@export var icon_texture: Texture2D
@export var item_type: String = ""
@export var can_be_mined: bool = false
@export var can_be_placed: bool = false
@export var can_be_consumed: bool = false
@export var need_silk_touch_to_mine: bool = false
@export var mined_dropped_object: String = ""
@export var silk_touch_mined_dropped_item: String = ""
@export var stack_size: int = 16
@export var block_model: int = 0
 
