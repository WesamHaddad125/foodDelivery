extends Node2D
class_name GameController

@onready var environment: TileMapLayer = $"y-sort-objects/Environment"
@onready var game_time_timer: Timer = $GameTimeTimer

var world_data : WorldData = preload("res://Scenes/Resources/WorldData.tres")

func _ready() -> void:
	Global.game_controller = self
	call_deferred("init_houses")
	
func init_houses() -> void:
	game_time_timer.wait_time = world_data.game_time_left_minutes * 60.0
	game_time_timer.start()
	for house in environment.get_children():
		if house is House && !world_data.houses.has(house.name):
			world_data.houses[house.name] = {
				"visited": false
			}
	ResourceSaver.save(world_data, "user://WorldData.tres")


func _on_boss_entrance_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://Scenes/Boss/boss_arena.tscn")


func _on_game_time_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Boss/boss_arena.tscn")
