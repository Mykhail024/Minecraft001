extends Node

const TOP : Array = [
	Vector3(0, 1, 0),
	Vector3(1, 1, 0),
	Vector3(1, 1, 1),
	Vector3(0, 1, 1)
]

const BOTTOM : Array = [
	Vector3(0, 0, 0),
	Vector3(0, 0, 1),
	Vector3(1, 0, 1),
	Vector3(1, 0, 0)
]

const LEFT : Array = [
	Vector3(0, 1, 1),
	Vector3(0, 0, 1),
	Vector3(0, 0, 0),
	Vector3(0, 1, 0)
]

const RIGHT : Array = [
	Vector3(1, 1, 0),
	Vector3(1, 0, 0),
	Vector3(1, 0, 1),
	Vector3(1, 1, 1)
]

const FRONT : Array = [
	Vector3(1, 1, 1),
	Vector3(1, 0, 1),
	Vector3(0, 0, 1),
	Vector3(0, 1, 1)
]

const BACK : Array = [
	Vector3(0, 1, 0),
	Vector3(0, 0, 0),
	Vector3(1, 0, 0),
	Vector3(1, 1, 0)
]
