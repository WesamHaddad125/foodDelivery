extends EnemyState
	
func enter(previous_state_path: String, data := {}) -> void:
	enemy.animation_player.play("Idle")
	
func physics_update(_delta: float) -> void:
	if enemy.has_line_of_sight():
		finished.emit(SEEKING)
	
func exit() -> void:
	enemy.animation_player.stop()
	
