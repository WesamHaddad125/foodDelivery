extends BossState

var dirToPlayer = Vector2.ZERO
var projectile = preload("res://Scenes/Enemies/enemy_projectile.tscn")

func enter(previous_state_path: String, data := {}) -> void:
	dirToPlayer = (enemy.player.global_position - enemy.global_position).normalized()
	
	for i in range(8):
		var projInstance1 : EnemyProjectile = projectile.instantiate()
		projInstance1.position = enemy.global_position
		projInstance1.direction = enemy.global_position.direction_to(enemy.player.global_position.rotated(deg_to_rad(15 * i)))
		var projInstance2 : EnemyProjectile = projectile.instantiate()
		projInstance2.position = enemy.global_position
		projInstance2.direction = enemy.global_position.direction_to(enemy.player.global_position.rotated(deg_to_rad(-15 * (i + 1))))
		enemy.add_child(projInstance1)
		enemy.add_child(projInstance2)
		await get_tree().create_timer(0.2).timeout
	
	finished.emit(DETECT_PLAYER)
