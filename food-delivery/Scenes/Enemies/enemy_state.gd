class_name EnemyState extends State

const IDLE = "Idle"
const SEEKING = "Seeking"
const ATTACKING = "Attacking"
const CIRCLING = "Circling"
const APPROACHING = "Approaching"

var enemy : Enemy

func _ready() -> void:
	await  owner.ready
	enemy = owner as Enemy
	assert(enemy != null, "The PlayerState state type must be used only in the enemy scene. It needs the owner to be a enemy node")
