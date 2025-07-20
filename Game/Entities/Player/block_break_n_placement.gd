extends Node3D

@export var interaction_ray: RayCast3D
@export var player: CharacterBody3D

@export var player_inventory: PlayerInventory

@export var coord_label: Label

var outline_cube: MeshInstance3D
var collision_check_body: Area3D

var voxel_terrain: VoxelTerrain
var voxel_tool: VoxelTool

var current_targeted_block: Vector3i
var current_target_block_normal: Vector3

func _ready() -> void:
	outline_cube = create_outline_cube()
	collision_check_body = create_outline_block_collision()
	
	if Data.world.voxel_terrain: voxel_terrain = Data.world.voxel_terrain
	voxel_tool = voxel_terrain.get_voxel_tool()

func _process(delta: float) -> void:
	update_collision_check_body()
	update_outline()
	block_deystroy()
	block_placement()
	
	coord_label.text = str(player.position)


## <--- BLOCK PLACEMENT AND DEYSTORY ---> ##

func block_deystroy():
	if Input.is_action_just_pressed("attack"):
		var current_voxel_type = voxel_tool.get_voxel(current_targeted_block)
		if current_voxel_type != TerrainData.AIR:
			voxel_tool.set_voxel(current_targeted_block, TerrainData.AIR)

func block_placement():
	if Input.is_action_just_pressed("interact") and player_inventory.selected_item != null and can_place_block():
		var item: Item = player_inventory.selected_item
		
		if !item.can_be_placed: return
		
		var place_block_type = item.block_model
		var tool = voxel_terrain.get_voxel_tool()

		tool.set_channel(VoxelBuffer.CHANNEL_TYPE)

		var place_pos = current_targeted_block + Vector3i(current_target_block_normal)

		var block_type = tool.get_voxel(place_pos)
		
		if block_type == TerrainData.AIR:
			tool.set_voxel(place_pos, place_block_type)




## <--- OUTLINE_BOX --> ##

func create_outline_cube() -> MeshInstance3D:
	var cube = MeshInstance3D.new()
	var cube_mesh = BoxMesh.new()
	cube_mesh.size = Vector3(1.01, 1.01, 1.01)
	cube.mesh = cube_mesh
	
	cube.visible = false
	cube.position = Vector3.ZERO
	
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(1, 1, 1, 0.1)
	cube.material_override = mat
	cube.scale = Vector3(1, 1, 1)
	
	if Data.world:
		var node: Node3D = Data.world.dimensions
		node.add_child(cube)
	
	return cube

func update_outline() -> void:
	if interaction_ray.is_colliding():
		var hit_position = interaction_ray.get_collision_point()
		current_target_block_normal = interaction_ray.get_collision_normal()
		var block_position = (hit_position - current_target_block_normal * 0.5).floor()
		current_targeted_block = Vector3i(block_position)

		outline_cube.global_position = block_position + Vector3(0.5, 0.5, 0.5)
		outline_cube.visible = true
	else:
		outline_cube.visible = false



## <--- COLLISION CHECKING BODY ---> ##

func create_outline_block_collision() -> Area3D:
	var area: Area3D = Area3D.new()
	var collision_body: CollisionShape3D = CollisionShape3D.new()
	
	var collision_shape: Shape3D = BoxShape3D.new()
	collision_shape.size = Vector3(1, 1, 1)
	
	collision_body.shape = collision_shape
	
	area.collision_layer = 0
	area.collision_mask = 2
	
	add_child(area)
	area.add_child(collision_body) 
	
	return area

func update_collision_check_body()-> void:
	var place_pos = Vector3(current_targeted_block) + current_target_block_normal + Vector3(0.5, 0.5, 0.5)
	collision_check_body.global_position = place_pos
	
func can_place_block() -> bool:
	var bodies = collision_check_body.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("player"):
			return false
	
	return true
		
		
