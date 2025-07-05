extends Node3D

@export var interaction_ray: RayCast3D
var outline_cube: MeshInstance3D
var voxel_terrain: VoxelTerrain
var voxel_tool: VoxelTool

var current_targeted_block: Vector3i


func _ready() -> void:
	outline_cube = create_outline_cube()
	if Data.world.voxel_terrain: voxel_terrain = Data.world.voxel_terrain
	voxel_tool = voxel_terrain.get_voxel_tool()

func _process(delta: float) -> void:
	check_inputs()
	update_outline()

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
	mat.albedo_color = Color(1, 1, 1, 0.1)  # bright red
	mat.emission_enabled = true
	mat.emission = Color(1, 0, 0)
	cube.material_override = mat
	cube.scale = Vector3(1, 1, 1)
	
	if Data.world:
		var node: Node3D = Data.world.dimensions
		node.add_child(cube)
	
	return cube

func check_inputs() -> void:
	if Input.is_action_just_pressed("attack"):
		var current_voxel_type = voxel_tool.get_voxel(current_targeted_block)
		
		if current_voxel_type != TerrainData.AIR:
			voxel_tool.set_voxel(current_targeted_block, TerrainData.AIR)
	

func update_outline() -> void:
	if interaction_ray.is_colliding():
		var hit_position = interaction_ray.get_collision_point()
		var hit_normal = interaction_ray.get_collision_normal()
		var block_position = (hit_position - hit_normal * 0.5).floor()
		current_targeted_block = Vector3i(block_position)

		outline_cube.global_position = block_position + Vector3(0.5, 0.5, 0.5)
		outline_cube.visible = true
	else:
		outline_cube.visible = false
		
		
