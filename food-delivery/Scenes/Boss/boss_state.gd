class_name BossState extends State

const SEEKING = "Seeking"
const ATTACKING = "Attacking"

var enemy : Boss

func _ready() -> void:
	await  owner.ready
	enemy = owner as Boss
	assert(enemy != null, "The BossState state type must be used only in the boss scene. It needs the owner to be a boss node")
