extends BossState

var move_dir = Vector2.ZERO

func enter(previous_state_path: String, data := {}) -> void:
	move_dir = (enemy.player.global_position - enemy.global_position).normalized()
	enemy.reset_tween()
	enemy.tween = create_tween()
	enemy.tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	enemy.tween.tween_property(enemy.sprite, "rotation", deg_to_rad(360), enemy.roll_time)
	# enemy.tween.tween_property(enemy, "global_position", enemy.player.global_position * 1.3, enemy.roll_time)
	enemy.tween.tween_callback(end_roll)
	
func physics_update(_delta: float) -> void:
	var collision = enemy.move_and_collide(enemy.velocity * _delta)
	
	if collision != null && collision.get_collider() is not WalkingPlayer:
		enemy.velocity = Vector2.ZERO
		await get_tree().create_timer(1.4).timeout
		if (enemy.global_position.distance_to(enemy.player.global_position) < 100):
			finished.emit(AVOID_PLAYER)
		else:
			finished.emit(DETECT_PLAYER)
	elif collision != null && collision.get_collider() is WalkingPlayer:
		enemy.player.health_component.damage(10.0)
		var knockback_dir = (enemy.player.global_position - enemy.global_position).normalized()
		enemy.player.apply_knockback(knockback_dir, 8, 0.25)
		finished.emit(AVOID_PLAYER)
		
	
func end_roll() -> void:
	enemy.velocity = move_dir * enemy.roll_speed 
	enemy.sprite.rotation = deg_to_rad(0)
