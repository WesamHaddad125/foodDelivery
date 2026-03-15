extends MeleeEnemyState

@onready var random_pos_timer: Timer = $"../../RandomPosTimer"
var interestVectors : Array[float]
var followPath : Path2D

func enter(previous_state_path: String, data := {}) -> void:
	enemy.player.target_converge_selector.converge.connect(_try_to_converge)
	enemy.player.target_converge_selector.convergingEntities.append(enemy)
	
func exit() -> void:
	enemy.player.target_converge_selector.converge.disconnect(_try_to_converge)
	
	var convergeIdx = enemy.player.target_converge_selector.convergingEntities.find(enemy)
	if convergeIdx >= 0:
		enemy.player.target_converge_selector.convergingEntities.remove_at(convergeIdx)
	
func physics_update(_delta: float) -> void:
	set_interests()
	enemy.set_dangers()
	enemy.choose_direction()
	enemy.queue_redraw()
	enemy.velocity = enemy.velocity.lerp(enemy.chosen_dir * 60, 0.8)
	enemy.move_and_slide()
	
	if (enemy.global_position.distance_to(enemy.player.global_position) > 120):
		finished.emit(SEEKING)
		
	if (enemy.global_position.distance_to(enemy.player.global_position) < enemy.attack_distance):
		finished.emit(ATTACKING)

func _on_random_pos_timer_timeout() -> void:
	enemy.player.enemy_circle_pos.progress_ratio = randf()
	# enemy.target = enemy.player.enemy_circle_pos

func set_interests():
	var direction = (enemy.target.global_position - enemy.global_position)
	direction = direction.normalized()
	
	var orbit_dir = Vector2(-direction.y, direction.x)
	for i in enemy.arr_context_map.size():
		enemy.arr_interest[i] = enemy.arr_context_map[i].dot(orbit_dir)
		
func _try_to_converge(nodeNames : Array, targetPos : Vector2) -> void:
	if nodeNames.has(enemy.name):
		finished.emit(APPROACHING)
