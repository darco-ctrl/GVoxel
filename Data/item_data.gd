extends Node

class Dirt:
	const icon: String = "res://Assets/blocks/dirt.png"
	const model: int = TerrainData.DIRT
	const is_placable: bool = true

class Stone:
	const icon: String = "res://Assets/blocks/stone.png"
	const model: int = TerrainData.STONE
	const is_placable: bool = true

class Grass:
	const icon: String = "res://Assets/blocks/grass_top.png"
	const model: int = TerrainData.GRASS
	const is_placeable: bool = true

class Air:
	const model: int = TerrainData.AIR
