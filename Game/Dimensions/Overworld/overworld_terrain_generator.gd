extends VoxelGeneratorScript

var noise: Noise = FastNoiseLite.new()

const WORLD_HEIGHT: int = 300

func _init():
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.006 
	noise.seed = 123456

func _generate_block(buffer: VoxelBuffer, origin: Vector3i, lod: int) -> void:
	var size = buffer.get_size()
	var channel = VoxelBuffer.CHANNEL_TYPE

	for z in size.z:
		for x in size.x:
			var global_voxel_position_x = origin.x + x
			var global_voxel_position_y = origin.z + z
			var height = int((noise.get_noise_2d(global_voxel_position_x, global_voxel_position_y) + 1.0) * 32.0 + 32.0)

			
			for y in size.y:
				var world_y = origin.y + y
				var block_type = TerrainData.AIR
				if world_y > height or world_y < 0:
					continue
				elif world_y > height - 1:
					block_type = TerrainData.GRASS
				elif world_y > height - 5: 
					block_type = TerrainData.DIRT
				else:
					block_type = TerrainData.STONE
				
				buffer.set_voxel(block_type, x, y, z, channel)
				
				if world_y == height and world_y < 70 and world_y > 60 and randi() % 50 == 0:
					spawn_tree(buffer, Vector3i(x, y + 1, z))

func spawn_tree(buffer: VoxelBuffer, pos: Vector3i):
	var wood_type = 5
	var leaf_type = 4
	
	for i in 3:
		var trunk_pos = pos + Vector3i(0, i, 0)
		if is_in_bounds(buffer, trunk_pos):
			buffer.set_voxel(wood_type, trunk_pos.x, trunk_pos.y, trunk_pos.z, VoxelBuffer.CHANNEL_TYPE)

	for dx in [-1, 0 , 1]:
		for dz in [-1, 0, 1]:
				if dx != 0 or dz != 0:
					var leaf_pos = pos + Vector3i(dx, 3, dz)
					if is_in_bounds(buffer, leaf_pos):
						buffer.set_voxel(leaf_type, leaf_pos.x, leaf_pos.y, leaf_pos.z, VoxelBuffer.CHANNEL_TYPE)

	
	
func is_in_bounds(buffer: VoxelBuffer, pos: Vector3i) -> bool:
	var size = buffer.get_size()
	return pos.x >= 0 and pos.x < size.x and \
		   pos.y >= 0 and pos.y < size.y and \
		   pos.z >= 0 and pos.z < size.z
