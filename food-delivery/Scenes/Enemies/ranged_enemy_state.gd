class_name RangedEnemyState extends State

const IDLE = "Idle"
const SEEKING = "Seeking"
const ATTACKING = "Attacking"

var enemy : RangedEnemy

func _ready() -> void:
	await  owner.ready
	enemy = owner as RangedEnemy
	assert(enemy != null, "The RangedEnemyState state type must be used only in the ranged enemy scene. It needs the owner to be a ranged enemy node")
