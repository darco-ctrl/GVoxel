
extends VoxelGeneratorScript

var flip_placement: bool = false

func _generate_block(buffer: VoxelBuffer, origin: Vector3i, lod: int) -> void:
	var size = buffer.get_size()
	var channel = VoxelBuffer.CHANNEL_TYPE
	
	# Only run if this chunk includes y=0
	if origin.y > 0 or origin.y + size.y <= 0:
		return

	for z in range(size.z):
		for x in range(size.x):
			var global_x = origin.x + x
			var global_z = origin.z + z
			var local_y = -origin.y  # y=0 in global space maps to this local y

			var is_checkered = (global_x + global_z) % 2 == 0
			var block_type = ItemManger.BLOCK_TYPE.CHECKERED_ONE if is_checkered else ItemManger.BLOCK_TYPE.CHECKERED_TWO

			# Make sure it's in bounds!
			if local_y >= 0 and local_y < size.y:
				buffer.set_voxel(block_type, x, local_y, z, channel)
