extends WalkingPlayerState

@export var roll_speed := 15000.0
@export var roll_time := 0.3
var move_dir : Vector2

func enter(previous_state_path: String, data := {}) -> void:
	move_dir = data["move_dir"].normalized()
	player.is_rolling = true
	player.reset_tween()
	player.tween = create_tween()
	player.tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	player.tween.tween_property(player.sprite, "rotation", deg_to_rad(360), roll_time)
	player.tween.tween_callback(end_roll)

func exit() -> void:
	player.is_rolling = false
	
func physics_update(_delta: float) -> void:
	player.velocity = move_dir * roll_speed * _delta
	player.move_and_slide()
	
func end_roll() -> void:
	player.sprite.rotation = deg_to_rad(0)
	finished.emit(RUNNING)
