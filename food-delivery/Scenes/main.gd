extends Node2D
class_name GameController

@onready var environment: TileMapLayer = $Environment
@onready var game_time_timer: Timer = $GameTimeTimer

var world_data : WorldData = preload("res://Scenes/Resources/WorldData.tres")

func _ready() -> void:
	Global.game_controller = self
	call_deferred("init_houses")
	
func init_houses() -> void:
	game_time_timer.wait_time = world_data.game_time_left
	game_time_timer.start()
	for house in environment.get_children():
		if house is House && !world_data.houses.has(house.name):
			world_data.houses[house.name] = {
				"visited": false
			}
	ResourceSaver.save(world_data, "user://WorldData.tres")
