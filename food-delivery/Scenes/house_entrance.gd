extends Area2D
class_name House

@onready var enter_visual: Label = $EnterVisual

@export var visited := false

var world_data : WorldData = preload("res://Scenes/Resources/WorldData.tres")

func _on_body_entered(body: Node2D) -> void:
	enter_visual.visible = true

func _on_body_exited(body: Node2D) -> void:
	enter_visual.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && enter_visual.visible:
		world_data.game_time_left_minutes = Global.game_controller.game_time_timer.time_left / 60.0
		world_data.houses[name] = true
		ResourceSaver.save(world_data, "user://WorldData.tres")
		get_tree().change_scene_to_file("res://Scenes/inner_house.tscn")
