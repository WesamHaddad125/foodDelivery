extends Node
class_name HealthComponent

@export var max_health : float = 100.0
@export var current_health : float
@export var collision_shape : CollisionShape2D
@export var health_bar : CustomHealthBar



signal health_changed(current: float, max: float)
signal died

func _ready() -> void:
	if health_bar != null:
		setup_health_bar()
	
func setup_health_bar(currValue = null) -> void:
	if currValue != null:
		current_health = currValue
		health_bar._setup_health_bar(currValue, max_health)
	else:
		current_health = max_health
		health_bar._setup_health_bar(max_health, max_health)

func _emit() -> void:
	health_changed.emit(current_health, max_health)

func damage(amount: float) -> void:
	current_health = clamp(current_health - amount, 0.0, max_health)
	health_bar.change_value(current_health)
	if current_health == 0.0:
		died.emit()
		
func heal(amount: float) -> void:
	current_health = clamp(current_health + amount, 0.0, max_health)
	
