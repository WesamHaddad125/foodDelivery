extends EnemyState
	
func physics_update(_delta: float) -> void:
	enemy.set_interests()
	enemy.set_dangers()
	enemy.choose_direction()
	enemy.queue_redraw()
	enemy.velocity = enemy.velocity.lerp(enemy.chosen_dir * enemy.max_speed, enemy.steer_force)
	enemy.move_and_slide()
	
	if (enemy.global_position.distance_to(enemy.player.global_position) < 25):
		finished.emit(ATTACKING)
	
