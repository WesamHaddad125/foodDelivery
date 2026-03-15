extends RangedEnemyState

func enter(previous_state_path: String, data := {}) -> void:
	enemy.animation_player.play("attack")
	enemy.velocity = Vector2.ZERO
	
func check_if_attack_hit():
	if (enemy.global_position.distance_to(enemy.player.global_position) < enemy.attack_distance):
		enemy.player.health_component.damage(enemy.attack_damage)
	# finished.emit(CIRCLING)
