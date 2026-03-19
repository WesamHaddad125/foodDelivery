extends CharacterBody2D
class_name MeleeEnemy

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

var knockback : Vector2 = Vector2.ZERO
var knockback_timer : float = 0.0

signal final_enemy_killed

func _ready() -> void:
	player = get_tree().root.get_node("InnerHouse/YSorted/WalkingPlayer")
	final_enemy_killed.connect(player._has_killed_final_enemy)
	target = player
	resize_context_map()
	
	health_component.died.connect(_enemy_killed)
	
func _physics_process(delta: float) -> void:
	line_of_sight.target_position = to_local(player.global_position) 
	if (has_line_of_sight()):
		player.last_known_pos.global_position = player.global_position
		target = player
	elif !has_line_of_sight():
		target = player.last_known_pos
		
func has_line_of_sight():
	var collider = line_of_sight.get_collider()
	if collider is WalkingPlayer:
		return true
	else:
		return false
		
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
	#for i in arr_context_map.size():
		#var start_pos = arr_context_map[i]
		#var end_pos = chosen_dir * 30
		#if arr_interest[i] != null && arr_interest[i] > 0.2:
			#var end = (arr_context_map[i] * 30) * arr_interest[i]
			#draw_line(start_pos, end, Color(0,1,1,1), 1.0)
		#if arr_interest[i] != null && arr_interest[i] < 0.0:
			#end_pos = (arr_context_map[i] * 30) * -arr_interest[i]
			#draw_line(start_pos, end_pos, Color(1, 0, 0, 1), 1.0)
	lod_optimization()
	
func set_interests():
	var direction = (target.global_position - global_position)
	direction = direction.normalized()
	for i in arr_context_map.size():
		arr_interest[i] = direction.dot(arr_context_map[i])
		
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

func _enemy_killed() -> void:
	var convergeIdx = player.target_converge_selector.convergingEntities.find(self)
	if convergeIdx >= 0:
		player.target_converge_selector.convergingEntities.remove_at(convergeIdx)
	
	if randf() < item_drop_chance_percent / 100.0:
		var upgradeDropped : Upgrade = upgrades.pick_random()
		var upgradeNode : UpgradeNode = upgradeNode.instantiate()
		upgradeNode.upgrade = upgradeDropped
		upgradeNode.global_position = self.global_position
		call_deferred("add_sibling", upgradeNode)
		
	var enemies_left = get_parent().get_children().reduce(func (accum, child): return accum + 1 if child is MeleeEnemy || child is RangedEnemy else accum, 0)
	print(enemies_left)
	if enemies_left <= 1:
		final_enemy_killed.emit()
		final_enemy_killed.disconnect(player._has_killed_final_enemy)
		print("final enemy killed")
	
	queue_free()

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
