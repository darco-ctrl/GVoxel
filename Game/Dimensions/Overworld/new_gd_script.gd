extends VoxelGeneratorScript

var noise: Noise = FastNoiseLite.new()

const WORLD_HEIGHT: int = 20

func _init():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
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
				if world_y <= height:
					buffer.set_voxel(1, x, y, z, channel)
