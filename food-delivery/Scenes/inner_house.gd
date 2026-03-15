extends Node2D

var world_data : WorldData = preload("res://Scenes/Resources/WorldData.tres")
@onready var game_time_timer: Timer = $GameTimeTimer
@onready var floor: TileMapLayer = $Floor
@onready var time_left_label: Label = $Camera2D/CenterContainer/TimeLeftLabel

func _ready() -> void:
	game_time_timer.wait_time = world_data.game_time_left
	game_time_timer.start()
	
func _process(delta: float) -> void:
	time_left_label.text = str("%0.2f" % (game_time_timer.time_left / 60.0)," m")

func exit_house() -> void:
	world_data.game_time_left = Global.game_controller.game_time_timer.time_left
	# world_data.houses[name] = true 
	ResourceSaver.save(world_data, "user://WorldData.tres")
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
