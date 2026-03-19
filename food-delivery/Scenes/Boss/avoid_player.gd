extends BossState
	
func enter(previous_state_path: String, data := {}) -> void:
	enemy.target = enemy.player
	
func physics_update(_delta: float) -> void:
	var dirX = enemy.global_transform.x
	var dirY = enemy.global_transform.y
	var playerDir = enemy.target.global_position.normalized()
	var isPerpX = dirX.dot(playerDir) 
	var isPerpY = dirY.dot(playerDir)	
	
	var distToPlayer = enemy.global_position.distance_to(enemy.player.global_position)
	
	if (isPerpX > -0.05 && isPerpX < 0.05) || (isPerpY > -0.05 && isPerpY < 0.05):
		finished.emit(BOSS_ROLL)
	
	set_interests()
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
	
func set_interests():
	var direction1 = (enemy.target.global_position - enemy.global_position)
	direction1 = direction1.normalized()
	
	for i in enemy.arr_context_map.size():
		if enemy.global_position.distance_to(enemy.player.global_position) < 100.0:
			enemy.arr_interest[i] = -direction1.dot(enemy.arr_context_map[i])
		else:
			finished.emit(DETECT_PLAYER)
