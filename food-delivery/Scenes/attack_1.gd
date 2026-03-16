extends WalkingPlayerState

var attackContinued := false

func enter(previous_state_path: String, data := {}) -> void:
	player.currentWeapon.body_entered.connect(_on_sword_body_entered)
	player.currentWeapon.animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	player.velocity = Vector2.ZERO
	attackContinued = false
	player.currentWeapon.animation_player.play("attack1")
	player.is_attacking = true
	
	var target_angle = Vector2.UP.angle_to(player.velocity)
	if player.velocity.length() > 0:
		player.weapon_holster.rotation = target_angle
	
func exit() -> void:
	player.currentWeapon.animation_player.animation_finished.disconnect(_on_animation_player_animation_finished)
	player.currentWeapon.body_entered.disconnect(_on_sword_body_entered)
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("attack"):
		attackContinued = true
		
func physics_update(_delta: float) -> void:
	var move_dir = Input.get_vector("left", "right", "up", "down") 
	
	# Allow slow movement
	if move_dir != Vector2.ZERO:
		player.velocity = move_dir * player.currentWeapon.attack_move_speed * _delta
	player.move_and_collide(player.velocity)
	
func _unhandled_input(event: InputEvent) -> void:
	var move_dir = Input.get_vector("left", "right", "up", "down") 
	
	if event.is_action_pressed("roll") && player.velocity != Vector2.ZERO:
		finished.emit(ROLLING, {"move_dir": move_dir})
	
func combo_ended() -> void:
	if attackContinued:
		finished.emit(ATTACK_2)
	else:
		player.currentWeapon.animation_player.play("RESET")
		finished.emit(RUNNING)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "attack1"):
		combo_ended()
		
func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_node("HealthComponent"):
		var healthComponent : HealthComponent = body.get_node("HealthComponent")
		if healthComponent != null && player.is_attacking:
			# TODO Add raycast to see if player has line of sight
			var totalDamage = player.currentWeapon.combo_attacks[0].attack_damage * player.player_data.damageMultiplier
			body.health_component.damage(totalDamage)
