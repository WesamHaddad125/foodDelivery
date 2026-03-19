extends Node2D
class_name InnerHouse

var world_data : WorldData = preload("res://Scenes/Resources/WorldData.tres")
var player_data : PlayerData = preload("res://Scenes/Resources/player_data.tres")

@onready var game_time_timer: Timer = $GameTimeTimer
@onready var floor: TileMapLayer = $Floor
@onready var time_left_label: Label = $Camera2D/CenterContainer/TimeLeftLabel
@onready var walking_player: WalkingPlayer = $YSorted/WalkingPlayer


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
		
		# Save player data
		save_player_data()
		get_tree().change_scene_to_file("res://Scenes/main.tscn")

func save_player_data() -> void:
	player_data.currentHealth = walking_player.health_component.current_health
	ResourceSaver.save(player_data, "user://player_data.tres")

func _on_game_time_timer_timeout() -> void:
	save_player_data()
	get_tree().change_scene_to_file("res://Scenes/Boss/boss_arena.tscn")
