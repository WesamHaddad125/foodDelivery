extends RangedEnemyState
	
func enter(previous_state_path: String, data := {}) -> void:
	enemy.attack_timer.start()
	
func physics_update(_delta: float) -> void:
	enemy.set_interests()
	enemy.set_dangers()
	enemy.choose_direction()
	enemy.queue_redraw()
	if enemy.knockback_timer > 0.0:
		enemy.velocity = enemy.knockback
		enemy.knockback_timer -= _delta
		if enemy.knockback_timer <= 0.0:
			enemy.knockback = Vector2.ZERO
	else:
		enemy.velocity = enemy.velocity.lerp(enemy.chosen_dir * enemy.max_speed, enemy.steer_force)
	enemy.move_and_slide()

func _on_attack_timer_timeout() -> void:
	finished.emit(ATTACKING)
