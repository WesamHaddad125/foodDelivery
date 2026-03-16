extends CharacterBody2D
class_name WalkingPlayer

@onready var sprite: Sprite2D = $Sprite2D
@onready var weapon_holster: Node2D = $WeaponHolster
@onready var enemy_circle: Path2D = $EnemyCircle
@onready var last_known_pos: Node2D = $"../../LastKnownPos"
@onready var enemy_circle_pos: PathFollow2D = $EnemyCircle/PathFollow2D

@export var attack_damage := 20.0
@export var target_converge_selector : TargetConvergeSelector
@export var health_component : HealthComponent

signal final_enemy_killed

var currentWeapon : Weapon
var player_data : PlayerData = preload("res://Scenes/Resources/player_data.tres")

var tween
var lastMoveDir : Vector2 
var is_attacking := false
var is_rolling := false

func _ready() -> void:
	init_player_data()
	health_component.died.connect(_player_killed)
	currentWeapon = weapon_holster.get_child(0)

func init_player_data() -> void:
	health_component.max_health = player_data.maxHealth

func reset_tween() -> void: 
	if tween != null:
		tween.kill()

func _physics_process(delta: float) -> void:
	var move_dir = Input.get_vector("left", "right", "up", "down").normalized()
	
	if move_dir != Vector2.ZERO && !is_attacking:
		lastMoveDir = move_dir
		
func _player_killed() -> void:
	print("player killed")
	
func gain_upgrade(upgradeInfo : Upgrade) -> void:
	match(upgradeInfo.upgrade_property):
		"damage":
			player_data.damageMultiplier += upgradeInfo.upgrade_amount
		"move_speed":
			player_data.move_speed += upgradeInfo.upgrade_amount
	ResourceSaver.save(player_data, "user://player_data.tres")

func _has_killed_final_enemy() -> void:
	print("house cleared")
