extends Resource
class_name ComboAttack

@export var forward_move_speed := 30.0
@export var attack_damage := 10.0

func move_forward(player : WalkingPlayer) -> void:
	# Move tiny distance
	player.velocity = player.lastMoveDir * forward_move_speed
	await player.get_tree().create_timer(0.08).timeout
	player.velocity = Vector2.ZERO
