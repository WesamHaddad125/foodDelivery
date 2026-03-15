extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var time_left_label: Label = $Camera2D/CenterContainer/TimeLeftLabel
@onready var sprite: Sprite2D = $Sprite2D
@onready var game_time_timer: Timer = $"../GameTimeTimer"

func _process(delta: float) -> void:
	var minutes = floor(game_time_timer.time_left / 60.0)
	var seconds = int(game_time_timer.time_left) % 60
	time_left_label.text = "%d:%02d" % [minutes, seconds]
