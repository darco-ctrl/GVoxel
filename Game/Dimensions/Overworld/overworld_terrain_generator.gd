extends VoxelGeneratorScript

var noise: Noise = FastNoiseLite.new()

const WORLD_HEIGHT: int = 20

func _init():
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = 123456
	noise.frequency = 0.01

func _generate_block(buffer: VoxelBuffer, origin: Vector3i, lod: int) -> void:
	var size = buffer.get_size()
	var channel = VoxelBuffer.CHANNEL_TYPE

	for z in size.z:
		for x in size.x:
			var global_voxel_position_x = origin.x + x
			var global_voxel_position_y = origin.z + z
			var height = int(noise.get_noise_2d(global_voxel_position_x, global_voxel_position_y) * WORLD_HEIGHT + WORLD_HEIGHT)
			for y in size.y:
				var world_y = origin.y + y
				if world_y > height:
					continue
				elif world_y > height - 1:
					buffer.set_voxel(TerrainData.GRASS, x, y, z, channel)
				elif world_y > height - 5: 
					buffer.set_voxel(TerrainData.DIRT, x, y, z, channel)
				else:
					buffer.set_voxel(TerrainData.STONE, x, y, z, channel)
