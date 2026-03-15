extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var time_left_label: Label = $Camera2D/CenterContainer/TimeLeftLabel
@onready var sprite: Sprite2D = $Sprite2D
@onready var game_time_timer: Timer = $"../GameTimeTimer"

func _process(delta: float) -> void:
	time_left_label.text = str("%0.2f" % (game_time_timer.time_left / 60.0)," m")
