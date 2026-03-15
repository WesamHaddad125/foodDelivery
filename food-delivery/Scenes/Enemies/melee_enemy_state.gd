class_name MeleeEnemyState extends State

const IDLE = "Idle"
const SEEKING = "Seeking"
const ATTACKING = "Attacking"
const CIRCLING = "Circling"
const APPROACHING = "Approaching"

var enemy : MeleeEnemy

func _ready() -> void:
	await  owner.ready
	enemy = owner as MeleeEnemy
	assert(enemy != null, "The MeleeEnemyState state type must be used only in the enemy scene. It needs the owner to be a enemy node")
