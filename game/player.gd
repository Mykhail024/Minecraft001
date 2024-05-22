extends CharacterBody3D

@onready var camera : Camera3D = $Head/Camera3D
@onready var head : Node3D = $Head
@onready var raycast : RayCast3D = $Head/Camera3D/RayCast3D
@onready var block_outline : MeshInstance3D = $BlockOutline
@onready var current_block_label : Label = $Head/Camera3D/CurrentBlock

var current_block : int = 0
var current_block_internal : int = 0

var placeble_blocks = [Global.STONE, Global.DIRT, Global.GRASS]

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

signal place_block(pos : Vector3, t)
signal break_block(pos : Vector3)

func _ready() -> void:
	raycast.add_exception_rid(self.get_rid())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head_original_pos = head.position.y
	update_block_label()

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
	
	if Input.is_action_just_pressed("NextBlock"):
		current_block_internal += 1
		if current_block >= placeble_blocks.size():
			current_block_internal = placeble_blocks.size()-1
		current_block = current_block_internal%placeble_blocks.size()-1
		update_block_label()
	if Input.is_action_just_pressed("PrevBlock"):
		current_block_internal -= 1
		if(current_block_internal < 0):
			current_block_internal = 0
		current_block = current_block_internal%placeble_blocks.size()-1
		update_block_label()
		
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

	if raycast.is_colliding():
		var norm = raycast.get_collision_normal()
		var pos = raycast.get_collision_point() - norm * 0.5
		
		var bx = floor(pos.x) + 0.5
		var by = floor(pos.y) + 0.5
		var bz = floor(pos.z) + 0.5
		var bpos = Vector3(bx, by, bz)
		
		block_outline.global_position = bpos
		block_outline.visible = true

		if Input.is_action_just_pressed("Break"):
			emit_signal("break_block", pos)
		if Input.is_action_just_pressed("Place"):
			emit_signal("place_block", pos+norm, placeble_blocks[current_block])
	else:
		block_outline.visible = false
	
func update_block_label() -> void:
	if(placeble_blocks[current_block] == Global.STONE):
		current_block_label.text = "Stone"
	elif (placeble_blocks[current_block] == Global.DIRT):
		current_block_label.text = 'Dirt'
	elif (placeble_blocks[current_block] == Global.GRASS):
		current_block_label.text = "Grass"
