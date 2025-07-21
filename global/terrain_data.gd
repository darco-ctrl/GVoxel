extends Node

const AIR: int = 0
const GRASS: int = 1
const DIRT: int = 2
const STONE: int = 3

var items_parent: Node3D

var block_texture_folder: String = "res://assets/textures/blocks/"
var item_block_dropped: PackedScene = preload("res://game/items/dropped_items/item_block.tscn")

const DROPPED_ITEMS_SCENE: Array[Block_Data] = [
	null,
	preload("res://data/blocks/grass_block.tres"),
	preload("res://data/blocks/dirt.tres"),
	preload("res://data/blocks/stone.tres")
]

func init(node: Node3D)-> void:
	items_parent = node

func drop_item_block(block_type: int, pos: Vector3, does_player_has_silk_touch: bool)-> void:
	if block_type < TerrainData.DROPPED_ITEMS_SCENE.size() and block_type >= 0:
		
		var block_data: Block_Data = DROPPED_ITEMS_SCENE[block_type]
		if block_data == null: return
		
		var new_dropped_item: CharacterBody3D = item_block_dropped.instantiate() as Dropped_Block
		new_dropped_item.block_data = block_data
		new_dropped_item.dropped_with_silk_touch = does_player_has_silk_touch
		
		var item_texture: String = block_texture_folder
		if does_player_has_silk_touch and block_data.need_silk_touch_to_mine:
			item_texture += block_data.silk_touch_mined_item
		else:
			item_texture += block_data.mined_item
		
		var meterial: StandardMaterial3D = StandardMaterial3D.new()
		if item_texture.ends_with(".png"):
			meterial.albedo_texture = load(item_texture)
			meterial.uv1_scale = Vector3(2.0, 2.0, 2.0)
			meterial.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		else:
			meterial.albedo_color = Color(255, 0, 255)
		
		new_dropped_item.mesh.set_surface_override_material(0, meterial)
	
		items_parent.add_child(new_dropped_item)
		
		new_dropped_item.global_position = pos + Vector3(0.5, 1, 0.5)
	
