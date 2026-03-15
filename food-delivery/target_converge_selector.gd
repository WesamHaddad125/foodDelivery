extends Node
class_name TargetConvergeSelector

@export var targetToConvergeOn : Node2D
@export var convergingEntities : Array[Node2D]
@export var max_converging_entities : int = 1
@export var one_shot := false

@onready var reselect_timer: Timer = $ReselectTimer

signal converge(nodeNames : Array, targetPos : Vector2)

func _on_reselect_timer_timeout() -> void:
	var converge_count = randi_range(0, max_converging_entities)
	var finalEntitiesToConverge : Dictionary = {}
	
	if convergingEntities.size() > 0:
		for i in converge_count:
			finalEntitiesToConverge[convergingEntities.pick_random().name] = true
	
	converge.emit(finalEntitiesToConverge.keys(), targetToConvergeOn.global_position)
	if !one_shot:
		reselect_timer.start()
