extends PlayerState

@export var start_move_speed := 150.0
@export var max_move_speed := 20000.0
@export var acceleration := 200.0
@export var break_power := 150.0
var start_acceleration = acceleration
var move_speed := start_move_speed

func physics_update(_delta: float) -> void:
	var move_dir = Input.get_vector("left", "right", "up", "down") * move_speed
	
	if Input.is_action_pressed("brake"):
		player.velocity.x = move_toward(player.velocity.x, sign(move_dir.x) * 20, break_power * _delta)
		player.velocity.y = move_toward(player.velocity.y, sign(move_dir.y) * 20, break_power * _delta)
	else:
		acceleration = start_acceleration
		player.velocity.x = move_toward(player.velocity.x, move_dir.x, acceleration * _delta)
		player.velocity.y = move_toward(player.velocity.y, move_dir.y, acceleration * _delta)
	player.move_and_slide()
