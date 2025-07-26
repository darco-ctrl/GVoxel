extends CharacterBody3D
class_name Dropped_Block

@export var mesh: MeshInstance3D
var item: Item
var dropped_with_silk_touch: bool = false

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
		
	if global_position.y < 0:
		queue_free()
	
	move_and_slide()


func _animated_block(t: float)-> float:
	var y: float = 0
	
	y = sin(t * frequency) * amplitude
	
	return y


func _on_timer_timeout() -> void:
	queue_free()


func _on_player_detecting_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var plr_invo = body.player_inventory as Player_Inventory
		
		var did_item_added = plr_invo.add_item(item)
		
		if did_item_added:
			queue_free()
		
