extends Node3D

var chunk_scene = preload("res://Chunk.tscn")

@onready var chunks : Node3D = $Chunks
@onready var player : Node3D = $Player

var load_thread : Thread = Thread.new()

func _ready():
	for i in range(0, Global.WORLD_SIZE_CHUNK):
		for j in range(0, Global.WORLD_SIZE_CHUNK):
			var chunk = chunk_scene.instantiate()
			chunk.set_chunk_position(Vector2(i, j))
			chunks.add_child(chunk)
	
	player.global_position = Vector3((Global.WORLD_SIZE_CHUNK * Global.DIMENSION.x) / 2, Global.DIMENSION.y, (Global.WORLD_SIZE_CHUNK * Global.DIMENSION.z) / 2)
	
	#load_thread.start(_thread_process)
	
func _thread_process():
	Thread.set_thread_safety_checks_enabled(false)
	while(true):
		for c in chunks.get_children():
			var cx = c.chunk_position.x
			var cz = c.chunk_position.y
				
			var px = floor(player.position.x / Global.DIMENSION.x)
			var pz = floor(player.position.z / Global.DIMENSION.z)
				
			var new_x = posmod(cx - px - Global.WORLD_SIZE_CHUNK/2, Global.WORLD_SIZE_CHUNK) + px - Global.WORLD_SIZE_CHUNK/2
			var new_z = posmod(cz - pz - Global.WORLD_SIZE_CHUNK/2, Global.WORLD_SIZE_CHUNK) + pz - Global.WORLD_SIZE_CHUNK/2
		
			if new_x != cx or new_z != cz:
				c.set_chunk_position(Vector2(int(new_x), int(new_z)))
				c.generate()
				c.update()
	
