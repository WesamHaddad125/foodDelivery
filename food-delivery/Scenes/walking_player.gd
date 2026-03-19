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
@export var dungeon_generator : DungeonGenerator
@onready var custom_health_bar: CustomHealthBar = $"../../Camera2D/CustomHealthBar"

signal final_enemy_killed

var currentWeapon : Weapon
var player_data : PlayerData = preload("res://Scenes/Resources/player_data.tres")

var tween
var lastMoveDir : Vector2 
var is_attacking := false
var is_rolling := false

var knockback : Vector2 = Vector2.ZERO
var knockback_timer : float = 0.0

func _ready() -> void:
	init_player_data()
	health_component.health_bar = custom_health_bar
	health_component.setup_health_bar(player_data.currentHealth)
	health_component.died.connect(_player_killed)
	currentWeapon = weapon_holster.get_child(0)

func init_player_data() -> void:
	health_component.max_health = player_data.maxHealth
	health_component.current_health = player_data.currentHealth
	currentWeapon = player_data.currWeapon.instantiate()
	weapon_holster.add_child(currentWeapon)

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
	var col = dungeon_generator.lockedRoom.x
	var row = dungeon_generator.lockedRoom.y
	var spawnPos := Vector2i(col * 21, row * 29)
	dungeon_generator.lockedRoom = Vector2i.ZERO
	dungeon_generator.createDoors(col, row, spawnPos.x, spawnPos.y)
	
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration

func replace_weapon(newWeaponObj: Weapon):
	currentWeapon = newWeaponObj
	weapon_holster.get_child(0).queue_free()
	weapon_holster.add_child(newWeaponObj)
	var newWeaponResource = load("res://Scenes/Weapons/" + newWeaponObj.load_name + ".tscn")
	player_data.currWeapon = newWeaponResource
	ResourceSaver.save(player_data, "user://player_data.tres")
