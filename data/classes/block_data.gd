extends RefCounted
class_name Block_Data

var block_id: int
var is_solid: bool
var can_be_mined: bool

func _init(_block_id: int, _is_solid: bool=true, _can_be_mined: bool=true) -> void:
	block_id = _block_id
	is_solid = _is_solid
	can_be_mined = _can_be_mined
