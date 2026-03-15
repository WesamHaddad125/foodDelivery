extends Node2D
class_name InnerHouse

var world_data : WorldData = preload("res://Scenes/Resources/WorldData.tres")
@onready var game_time_timer: Timer = $GameTimeTimer
@onready var floor: TileMapLayer = $Floor
@onready var time_left_label: Label = $Camera2D/CenterContainer/TimeLeftLabel

func _ready() -> void:
	game_time_timer.wait_time = world_data.game_time_left_minutes * 60.0
	game_time_timer.start()
	
func _process(delta: float) -> void:
	var minutes = floor(game_time_timer.time_left / 60.0)
	var seconds = int(game_time_timer.time_left) % 60
	time_left_label.text = "%d:%02d" % [minutes, seconds]

func exit_house(body: Node2D) -> void:
	if body is WalkingPlayer:
		world_data.game_time_left_minutes = game_time_timer.time_left / 60.0
		# world_data.houses[name] = true 
		ResourceSaver.save(world_data, "user://WorldData.tres")
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
