extends CharacterBody3D

@export var headpivot: Node3D
@export var camera: Camera3D
@export var interaction_ray: RayCast3D
@export var item_group_node: Node3D

@export_range(0, 1, 0.001) var camera_sensitvity: float = 0.005

@export var max_speed: float = 5
@export var jump_velocity: float = 6.5
@export var gravity: float = 20.0

var lock_mouse: bool = false

var player_velocity: Vector3 = Vector3.ZERO
var head_transform: Basis

func _ready() -> void:
	Data.player = self

func _physics_process(delta: float) -> void:
	inputs_handler()
	player_movement(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and lock_mouse:
		headpivot.rotate_y(-event.relative.x * camera_sensitvity)
		camera.rotate_x(-event.relative.y * camera_sensitvity)

func inputs_handler() -> void:
	if Input.is_action_just_pressed("lock_mouse"):
		if lock_mouse:
			lock_mouse = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			lock_mouse = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func player_movement(deltatime: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	player_velocity = velocity
	player_velocity.y = 0
	
	if not is_on_floor():
		velocity.y -= gravity * deltatime
	
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_pressed("move_forward"): direction.z -= 1
	if Input.is_action_pressed("move_backward"): direction.z += 1
	if Input.is_action_pressed("move_left"): direction.x -= 1
	if Input.is_action_pressed("move_right"): direction.x += 1
	
	
	if is_on_floor():
		head_transform = headpivot.transform.basis
	
	direction = (head_transform * direction).normalized()
	
	player_velocity = direction * max_speed
	
	velocity = Vector3(player_velocity.x, velocity.y, player_velocity.z)

	move_and_slide()
