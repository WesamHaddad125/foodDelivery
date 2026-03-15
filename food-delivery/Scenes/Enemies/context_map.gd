extends Node2D
class_name ContextMap

var directions : PackedVector2Array = [
	Vector2(0,-1), 	# UP
	Vector2(1,-1), 	# TOP RIGHT
	Vector2(1,0), 	# RIGHT
	Vector2(1,1), 	# BOTTOM RIGHT
	Vector2(0,1), 	# BOTTOM
	Vector2(-1,1),	# BOTTOM LEFT
	Vector2(-1,0),	# LEFT
	Vector2(-1,-1) # TOP LEFT
]

var dangerArray : Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var contextMap : Array[float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var raycasts : Array[RayCast2D]

func _ready() -> void:
	for child in get_children():
		raycasts.append(child)

func _physics_process(delta: float) -> void:
	for i in range(dangerArray.size()):
		dangerArray[i] = 0
		
	for raycast in raycasts:
		var rayIdx = int(raycast.name)
		if raycast.is_colliding():
			dangerArray[rayIdx] += 5
			dangerArray[(rayIdx + 1) % dangerArray.size()] += 2
			dangerArray[(rayIdx - 1 + dangerArray.size()) % dangerArray.size()] += 2
