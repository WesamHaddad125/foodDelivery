extends Area2D
class_name Weapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var weapon_name := ""
@export var combo_attacks : Array[ComboAttack]
var player : WalkingPlayer
var is_projectile_weapon := false

func _ready() -> void:
	player = get_parent().get_parent() as WalkingPlayer
	if combo_attacks.is_empty():
		is_projectile_weapon = true

func move_forward(attackIdx) -> void:
	combo_attacks[attackIdx].move_forward(player)
