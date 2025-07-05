extends Node3D

@export var camera: Camera3D
@export var camera_pivot: Node3D
@export var camera_sensitivity: float = 0.003
@export var speed: float = 10

var lock_mouse: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && lock_mouse:
		camera_pivot.rotate_y(-event.relative.x * camera_sensitivity)
		camera.rotate_x(-event.relative.y * camera_sensitivity)
		#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(40), deg_to_rad(60))
		
func _physics_process(delta: float) -> void: 
	plaeyr_movement(delta);
	
func plaeyr_movement(deltatime: float) -> void:
	if Input.is_action_just_pressed("lock_mouse"):
		if lock_mouse:
			lock_mouse = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			lock_mouse = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var direction: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("move_forward"): direction.z -= 1
	if Input.is_action_pressed("move_backward"): direction.z += 1
	if Input.is_action_pressed("move_left"): direction.x -= 1
	if Input.is_action_pressed("move_right"): direction.x += 1
	if Input.is_action_pressed("move_up"): direction.y += 1
	if Input.is_action_pressed("move_down"): direction.y -= 1
	
	direction = (camera_pivot.transform.basis * direction).normalized()
	
	position += speed * direction * deltatime
			
