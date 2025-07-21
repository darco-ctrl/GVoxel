extends CharacterBody3D
class_name Dropped_Block

@export var mesh: MeshInstance3D

var frequency: float = 1
var amplitude: float = 0.05
var time: float = 0

func _process(delta: float) -> void:
	if Data.player:
		if 20 < global_position.distance_to(Data.player.global_position):
			visible = false
		else:
			visible = true	
	
	if !is_on_floor():
		velocity.y += delta * -20
	else:
		velocity.y = 0
	
	if visible == true:
		time += delta
		mesh.position.y = _animated_block(time)
		mesh.rotation.y += 0.005
		
		print("running")
		
	if global_position.y < 0:
		queue_free()
	
	move_and_slide()


func _animated_block(t: float)-> float:
	var y: float = 0
	
	y = sin(t * frequency) * amplitude
	
	return y
