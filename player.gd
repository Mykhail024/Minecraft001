extends CharacterBody3D

@onready var camera : Camera3D = $Head/Camera3D
@onready var head : Node3D = $Head

var head_original_pos

var camera_x_rotation = 0
var camera_y_rotation = 0

@export var camera_y_rotation_min = -90
@export var camera_y_rotation_max = 90

@export var mouse_sensitivity = 0.3
@export var movement_speed = 6
@export var gravity = 30
@export var jump_velocity = 8

var paused = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head_original_pos = head.position.y

func _input(event):
	if Input.is_action_just_pressed("Pause"):
		paused = !paused
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if paused:
		return

	if event is InputEventMouseMotion:
		camera_x_rotation += -event.relative.x * mouse_sensitivity
		camera_y_rotation += -event.relative.y * mouse_sensitivity
		
func _physics_process(delta):
	if(global_position.y < -Global.DIMENSION.y):
		global_position = Vector3((Global.WORLD_SIZE_CHUNK * Global.DIMENSION.x) / 2, Global.DIMENSION.y*2, (Global.WORLD_SIZE_CHUNK * Global.DIMENSION.z) / 2)
	if paused:
		return

	camera_y_rotation = clamp(camera_y_rotation, camera_y_rotation_min, camera_y_rotation_max)

	head.rotation_degrees.y = camera_x_rotation
	head.rotation_degrees.x = camera_y_rotation

	var basis = head.get_global_transform().basis

	var direction = Vector3()
	
	if Input.is_action_pressed("Shift"):
		var twin = create_tween()
		twin.tween_property(head, "position", Vector3(head.position.x, head_original_pos * 0.8, head.position.z), 0.1)
	elif head.position.y != head_original_pos:
		var twin = create_tween()
		twin.tween_property(head, "position", Vector3(head.position.x, head_original_pos, head.position.z), 0.1)
	
	var is_sprinted : bool = false
	if Input.is_action_pressed("Forward"):
		if Input.is_action_pressed("Shift"):
			direction -= basis.z/2
		elif Input.is_action_pressed("Sprint"):
			direction -= basis.z*1.5
			is_sprinted = true
		else:
			direction -= basis.z
	if Input.is_action_pressed("Backward"):
		direction += basis.z
	if Input.is_action_pressed("Left"):
		direction -= basis.x
	if Input.is_action_pressed("Right"):
		direction += basis.x
	
	velocity.z = direction.z * movement_speed
	velocity.x = direction.x * movement_speed

	if (Input.is_action_pressed("Jump") and is_on_floor()) or (not Input.is_action_pressed("Shift") and is_on_wall() and is_on_floor() and Input.is_action_pressed("Forward")):
		velocity.y += jump_velocity

	velocity.y -= gravity * delta
	
	if is_sprinted:
		var twin = create_tween()
		twin.tween_property(camera, "fov", 82, 0.1)
	elif camera.fov != 75:
		var twin = create_tween()
		twin.tween_property(camera, "fov", 75, 0.1)
		
	move_and_slide()

	
