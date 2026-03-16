extends Area2D
class_name Weapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



@export var attack_move_speed := 20.0
@export var weapon_name := ""
@export var combo_attacks : Array[ComboAttack]
@export var pitarang : PathFollow2D
var player : WalkingPlayer
var is_projectile_weapon := false

func _ready() -> void:
	player = get_parent().get_parent() as WalkingPlayer
	if combo_attacks.is_empty():
		is_projectile_weapon = true

func move_forward(attackIdx) -> void:
	combo_attacks[attackIdx].move_forward(player)

func _physics_process(delta: float) -> void:
	if weapon_name == "Pitarang":
		collision_shape_2d.global_position = pitarang.global_position
