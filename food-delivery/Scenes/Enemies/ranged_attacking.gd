extends RangedEnemyState
var projectile = preload("res://Scenes/Enemies/enemy_projectile.tscn")

func enter(previous_state_path: String, data := {}) -> void:
	enemy.velocity = Vector2.ZERO
	attack()
	finished.emit(SEEKING)
	
func attack() -> void:
	for i in range(3):
		var projInstance : EnemyProjectile= projectile.instantiate()
		projInstance.position = enemy.global_position
		projInstance.direction = enemy.global_position.direction_to(enemy.player.global_position)
		enemy.add_child(projInstance)
		await get_tree().create_timer(0.1).timeout
