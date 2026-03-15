extends WalkingPlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if previous_state_path == ATTACK_1 || previous_state_path == ATTACK_2 || previous_state_path == ATTACK_3:
			player.is_attacking = false

func physics_update(_delta: float) -> void:
	var move_dir = Input.get_vector("left", "right", "up", "down") 
	
	var target_angle = Vector2.UP.angle_to(player.velocity)
	if player.velocity.length() > 0:
		player.weapon_holster.rotation = lerp_angle(player.weapon_holster.rotation, target_angle, _delta * 30)
	
	player.velocity = move_dir * player.player_data.move_speed * _delta
	var collision = player.move_and_collide(player.velocity)
	if collision:
		if collision.get_collider() is not Enemy:
			player.velocity = player.velocity.slide(collision.get_normal())
			player.move_and_collide(collision.get_remainder().slide(collision.get_normal()))
		
func handle_input(_event: InputEvent) -> void:
	var move_dir = Input.get_vector("left", "right", "up", "down") 
	
	if _event.is_action_pressed("roll") && player.velocity != Vector2.ZERO:
		finished.emit(ROLLING, {"move_dir": move_dir})
	
	if _event.is_action_pressed("attack"):
		# Start melee combo
		if !player.currentWeapon.is_projectile_weapon:
			finished.emit(ATTACK_1)
