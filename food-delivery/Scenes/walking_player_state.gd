extends State
class_name WalkingPlayerState

const RUNNING = "Running"
const ROLLING = "Rolling"
const ATTACK_1 = "Attack1"
const ATTACK_2 = "Attack2"
const ATTACK_3 = "Attack3"

var player : WalkingPlayer

func _ready() -> void:
	await  owner.ready
	player = owner as WalkingPlayer
	assert(player != null, "The PlayerState state type must be used only in the walking player scene. It needs the owner to be a walking player node")
