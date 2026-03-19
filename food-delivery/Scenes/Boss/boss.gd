extends CharacterBody2D
class_name Boss

@export var move_speed : float = 3.0
@export var prediction_time := 0.2 
@export var offset_bias := 0.0
@export var corrective_radius := 0.0
@export var max_steer_force := 30.0
@export var attack_distance := 25.0
@export var attack_damage := 5.0
@export var item_drop_chance_percent := 20.0
@export var health_component : HealthComponent

@onready var context_map: ContextMap = $ContextMap
@onready var line_of_sight: RayCast2D = $LineOfSight
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Context Steer v3
@export var max_speed := 50.0
@export var steer_force := 0.09
@export var look_ahead = 50.0
@export var context_resolution = 8
@export var target : Node2D

var  arr_context_map = []
var arr_interest = []
var arr_dangers = []

var chosen_dir := Vector2.ZERO

var player : WalkingPlayer

@export var upgrades : Array[Upgrade]
var upgradeNode = preload("res://Scenes/Upgrades/upgradeScene.tscn")

signal final_enemy_killed
var tween

var knockback : Vector2 = Vector2.ZERO
var knockback_timer : float = 0.0

# Boss params
var use_roll_attack := true

@export var roll_time := 3.0
@export var roll_speed := 400.0
@export var randPos : PathFollow2D

@onready var ranged_attack_check: Timer = $RangedAttackCheck
@onready var random_position_timer: Timer = $RandomPositionTimer
@onready var custom_health_bar: CustomHealthBar = $"../Camera2D/BossHealth"

func _ready() -> void:
	player = get_tree().root.get_node("BossArena/YSorted/WalkingPlayer")
	target = player
	resize_context_map()
	
	custom_health_bar.max_value = health_component.max_health
	health_component.health_bar = custom_health_bar
	health_component.setup_health_bar()
	
func reset_tween() -> void: 
	if tween != null:
		tween.kill()

func _physics_process(delta: float) -> void:
	pass
	#if (has_line_of_sight()):
		#player.last_known_pos.global_position = player.global_position
		#target = player
	#elif !has_line_of_sight():
		#target = player.last_known_pos
		
#func has_line_of_sight():
	#var collider = line_of_sight.get_collider()
	#if collider is WalkingPlayer:
		#return true
	#else:
		#return false
		
func lod_optimization():
	var distance = target.global_position - global_position
	distance = abs(distance)
	if distance.x < 200:
		context_resolution = 16
	elif distance.x > 200 && distance.x < 400:
		context_resolution = 8
	elif distance.x > 400:
		context_resolution = 4
		
	resize_context_map()
		
func resize_context_map() -> void:
	arr_context_map.resize(context_resolution)
	arr_dangers.resize(context_resolution)
	arr_interest.resize(context_resolution)
	for i in context_resolution:
		var angle = i * TAU / context_resolution
		arr_context_map[i] = Vector2.RIGHT.rotated(angle)	
		
func _draw() -> void:
	for i in arr_context_map.size():
		var start_pos = arr_context_map[i]
		var end_pos = chosen_dir * 30
		if arr_interest[i] != null && arr_interest[i] > 0.2:
			var end = (arr_context_map[i] * 30) * arr_interest[i]
			draw_line(start_pos, end, Color(0,1,1,1), 1.0)
		if arr_interest[i] != null && arr_interest[i] < 0.0:
			end_pos = (arr_context_map[i] * 30) * -arr_interest[i]
			draw_line(start_pos, end_pos, Color(1, 0, 0, 1), 1.0)
	lod_optimization()
	
func set_interests():
	var direction1 = (target.global_position - global_position)
	direction1 = direction1.normalized()
	
	for i in arr_context_map.size():
		arr_interest[i] = direction1.dot(arr_context_map[i])
		
func set_dangers():
	var space_state = get_world_2d().direct_space_state
	for i in context_resolution:
		var query = PhysicsRayQueryParameters2D.create(position, position + arr_context_map[i] * look_ahead)
		var result = space_state.intersect_ray(query)
		arr_dangers[i] = 1.0 if result else 0.0 # Coult add weights if needed
		
func choose_direction():
	chosen_dir = Vector2.ZERO
	for i in context_resolution:
		if arr_dangers[i] > 0.0:
			arr_interest[i] = -3.0
		chosen_dir += arr_context_map[i] * arr_interest[i]
	chosen_dir = chosen_dir.normalized()

func _on_boss_roll_detector_body_entered(body: Node2D) -> void:
	use_roll_attack = true

func _on_boss_roll_detector_body_exited(body: Node2D) -> void:
	use_roll_attack = false
	
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
