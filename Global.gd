extends Node

var seed : int
const DIMENSION = Vector3(16, 64, 16)
const TEXTURE_ATLAS_SIZE = Vector2(4, 1)
const WORLD_SIZE_CHUNK : int = 16
const VISIBILITY = 4

func _ready():
	randomize()
	seed = randi()

enum {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	FRONT,
	BACK,
	SOLID
}
enum {
	AIR,
	GRASS,
	DIRT,
	STONE
}

const types = {
	AIR: {
		SOLID: false
	},
	GRASS: {
		TOP: Vector2(3, 0), BOTTOM: Vector2(1, 0), RIGHT: Vector2(2, 0),
		LEFT: Vector2(2, 0), FRONT: Vector2(2, 0), BACK: Vector2(2, 0),
		SOLID: true
	},
	DIRT: {
		TOP: Vector2(1, 0), BOTTOM: Vector2(1, 0), RIGHT: Vector2(1, 0),
		LEFT: Vector2(1, 0), FRONT: Vector2(1, 0), BACK: Vector2(1, 0),
		SOLID: true
	},
	STONE: {
		TOP: Vector2(0, 0), BOTTOM: Vector2(0, 0), RIGHT: Vector2(0, 0),
		LEFT: Vector2(0, 0), FRONT: Vector2(0, 0), BACK: Vector2(0, 0),
		SOLID: true
	}
}
