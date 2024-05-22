@tool
extends Node3D

var mesh : ArrayMesh = null
var mesh_instance : MeshInstance3D = null

var blocks = []

var verts : PackedVector3Array
var normals : PackedVector3Array
var indices : PackedInt32Array
var uvs : PackedVector2Array

var mesh_arrays = []

var material : Material = preload("res://sprites/blocks/atlas_material.tres")

var chunk_position = Vector2()

var noise = FastNoiseLite.new()

func _ready():
	material.set("texture_filter", "Nearest")
	create_instance()
	generate()
	update()

func generate() -> void:
	blocks = []
	blocks.resize(Global.DIMENSION.x)
	for x in range(0, Global.DIMENSION.x):
		blocks[x] = []
		blocks[x].resize(Global.DIMENSION.y)
		for y in range(0, Global.DIMENSION.y):
			blocks[x][y] = []
			blocks[x][y].resize(Global.DIMENSION.z)
			for z in range(0, Global.DIMENSION.z):
				var global_pos = chunk_position * \
					Vector2(Global.DIMENSION.x, Global.DIMENSION.z) + \
					Vector2(x, z)
				noise.set_seed(Global.seed)
				var height = int((noise.get_noise_2dv(global_pos) + 1)/2 * Global.DIMENSION.y)
				
				var block = Global.AIR
				if y < height / 2:
					block = Global.STONE
				elif y < height:
					block = Global.DIRT
				elif y == height:
					block = Global.GRASS
				blocks[x][y][z] = block

func update() -> void:
	verts = []
	normals = []
	indices = []
	uvs = []
	for x in Global.DIMENSION.x:
		for y in Global.DIMENSION.y:
			for z in Global.DIMENSION.z:
				create_block(Vector3(x, y, z))
	commit()
	self.visible = true

func commit() -> void:
	mesh_arrays[Mesh.ARRAY_VERTEX] = verts
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	mesh_arrays[Mesh.ARRAY_INDEX] = indices
	mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs
	
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)
	mesh.surface_set_material(0, material)

	mesh_instance.set_mesh(mesh)
	mesh_instance.create_trimesh_collision()


func create_instance() -> void:
	if mesh_instance != null:
		mesh_instance.call_deferred("queue_free")
		mesh_instance = null
		
	mesh_arrays.resize(ArrayMesh.ARRAY_MAX)
	
	mesh_instance = MeshInstance3D.new()
	mesh_instance.set("lod_bias", 0.3)
	mesh_instance.set("visibility_range_end", Global.VISIBILITY * Global.DIMENSION.x)
	self.add_child(mesh_instance)

func check_transparent(cord: Vector3) -> bool:
	if cord.x >= 0 and cord.x < Global.DIMENSION.x and \
		cord.y >= 0 and cord.y < Global.DIMENSION.y and \
		cord.z >= 0 and cord.z < Global.DIMENSION.z:
			return not Global.types[blocks[cord.x][cord.y][cord.z]][Global.SOLID]
	return true

func create_block(cord : Vector3) -> void:
	var block = blocks[cord.x][cord.y][cord.z]
	if block == Global.AIR:
		return
	
	var block_info = Global.types[block]
	
	if check_transparent(Vector3(cord.x, cord.y + 1, cord.z)):
		create_face(Block.TOP, cord, block_info[Global.TOP])
	if check_transparent(Vector3(cord.x, cord.y - 1, cord.z)):
		create_face(Block.BOTTOM, cord, block_info[Global.BOTTOM])
	if check_transparent(Vector3(cord.x - 1, cord.y, cord.z)):
		create_face(Block.LEFT, cord, block_info[Global.LEFT])
	if check_transparent(Vector3(cord.x + 1, cord.y, cord.z)):
		create_face(Block.RIGHT, cord, block_info[Global.RIGHT])
	if check_transparent(Vector3(cord.x, cord.y, cord.z + 1)):
		create_face(Block.FRONT, cord, block_info[Global.FRONT])
	if check_transparent(Vector3(cord.x, cord.y, cord.z - 1)):
		create_face(Block.BACK, cord, block_info[Global.BACK])

func create_face(side : Array, offset : Vector3, texture_atlas_offset : Vector2) -> void:
	var length = len(verts)
	var _verts : PackedVector3Array = [
		side[0] + offset,
		side[1] + offset,
		side[2] + offset,
		side[3] + offset
	]
	
	var uv_offset = texture_atlas_offset / Global.TEXTURE_ATLAS_SIZE
	var height = 1.0 / Global.TEXTURE_ATLAS_SIZE.y
	var width = 1.0 / Global.TEXTURE_ATLAS_SIZE.x
	
	indices.append_array([length, length+1, length+2, length, length+2, length+3])
	verts.append_array(_verts)
	normals.append_array([_verts[0].normalized(), _verts[1].normalized(), _verts[2].normalized(), _verts[3].normalized()])
	uvs.append_array([
			Vector2(0, 0) + uv_offset,
			Vector2(0, height) + uv_offset,
			Vector2(width, height) + uv_offset,
			Vector2(width, 0) + uv_offset
		])
	
func set_chunk_position(pos : Vector2):
	chunk_position = pos
	position = Vector3(pos.x, 0, pos.y) * Global.DIMENSION
	self.visible = false
