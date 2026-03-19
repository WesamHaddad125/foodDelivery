extends MeleeEnemyState

func enter(previous_state_path: String, data := {}) -> void:
	enemy.animation_player.play("attack")
	enemy.velocity = Vector2.ZERO
	
func check_if_attack_hit():
	if (enemy.global_position.distance_to(enemy.player.global_position) < enemy.attack_distance):
		enemy.player.health_component.damage(enemy.attack_damage)
		
		var knockback_dir = (enemy.player.global_position - enemy.global_position).normalized()
		enemy.player.apply_knockback(knockback_dir, 3.5, 0.12)
	finished.emit(CIRCLING)
