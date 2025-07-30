extends Node

enum BLOCK_TYPE {
	AIR,
	GRASS,
	DIRT,
	STONE,
	LEAF,
	LOG,
	CHECKERED_ONE,
	CHECKERED_TWO
}

var items_parent: Node3D

const BLOCK_TEXTURE_FOLDER: String = "res://assets/textures/blocks/"
const ITEM_FOLDER: String = "res://data/items/"

var item_block_dropped: PackedScene = preload("res://game/items/dropped_items/item_block.tscn")

var blocks_data: Array[Block_Data] = [
	null, 
	Block_Data.new(BLOCK_TYPE.GRASS),  
	Block_Data.new(BLOCK_TYPE.DIRT),
	Block_Data.new(BLOCK_TYPE.STONE),
	Block_Data.new(BLOCK_TYPE.LEAF),
	Block_Data.new(BLOCK_TYPE.LOG),
	Block_Data.new(BLOCK_TYPE.CHECKERED_ONE, true, false),
	Block_Data.new(BLOCK_TYPE.CHECKERED_TWO, true, false)
]

var ITEM_FILE_NAMES: Array[String] = [
	"",
	"grass.tres",
	"dirt.tres",
	"stone.tres",
	"",
	"",
	"",
	""
]

func init(node: Node3D)-> void:
	items_parent = node

func load_item(item_name: String)-> Item:
	
	var item: Item
	var item_file_name = item_name + ".tres"
	
	if ITEM_FILE_NAMES.has(item_file_name):
		item = load(ITEM_FOLDER + item_file_name)
	
		return item
		
	return null

func drop_item_block(block_type: int, pos: Vector3, does_player_has_silk_touch: bool)-> void:
	if block_type < blocks_data.size() and block_type >= 0:
		
		var current_block_data: Block_Data = blocks_data[block_type]
		if current_block_data == null: return
		
		var item_name: String = ITEM_FILE_NAMES[block_type]
		
		if item_name == "": return
		
		var new_item: Item = load(ITEM_FOLDER + item_name)
		
		var new_dropped_item: Dropped_Block = item_block_dropped.instantiate() as Dropped_Block
		new_dropped_item.item = new_item
		
		items_parent.add_child(new_dropped_item)
		
		new_dropped_item.global_position = pos + Vector3(0.5, 1, 0.5)
