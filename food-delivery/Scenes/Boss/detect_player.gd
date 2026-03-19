extends BossState

func enter(previous_state_path: String, data := {}) -> void:
	if (previous_state_path == BossState.AVOID_PLAYER):
		enemy.randPos.progress_ratio = randf()
		enemy.target = enemy.randPos
	enemy.random_position_timer.start()
	
func exit() -> void:
	enemy.random_position_timer.stop()

func physics_update(_delta: float) -> void:	
	var dirX = enemy.global_transform.x
	var dirY = enemy.global_transform.y
	var playerDir = enemy.target.global_position.normalized()
	var isPerpX = dirX.dot(playerDir) 
	var isPerpY = dirY.dot(playerDir)	
	
	var distToPlayer = enemy.global_position.distance_to(enemy.player.global_position)
	
	if enemy.use_roll_attack && ((isPerpX > -0.05 && isPerpX < 0.05) || (isPerpY > -0.05 && isPerpY < 0.05)):
		finished.emit(BOSS_ROLL)
	
	print(distToPlayer)
	if enemy.global_position.distance_to(enemy.target.global_position) < 40:
		enemy.randPos.progress_ratio = randf()
		enemy.target = enemy.randPos
	if distToPlayer < 70:
		finished.emit(AVOID_PLAYER)

	enemy.set_interests()
	enemy.set_dangers()
	enemy.choose_direction()
	if enemy.knockback_timer > 0.0:
		enemy.velocity = enemy.knockback
		enemy.knockback_timer -= _delta
		if enemy.knockback_timer <= 0.0:
			enemy.knockback = Vector2.ZERO
	else:
		enemy.velocity = enemy.velocity.lerp(enemy.chosen_dir * enemy.max_speed, enemy.steer_force)
	enemy.move_and_slide()

func _on_random_position_timer_timeout() -> void:
	enemy.randPos.progress_ratio = randf()
	enemy.target = enemy.randPos


func _on_ranged_attack_check_timeout() -> void:
	var distToPlayer = enemy.global_position.distance_to(enemy.player.global_position)
	
	if !enemy.use_roll_attack:
		finished.emit(BOSS_FIRE)
