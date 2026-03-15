extends Node
class_name HealthComponent

@export var max_health : float = 100.0
@export var current_health : float
@export var collision_shape : CollisionShape2D

signal health_changed(current: float, max: float)
signal died

func _ready() -> void:
	current_health = max_health

func _emit() -> void:
	health_changed.emit(current_health, max_health)

func damage(amount: float) -> void:
	current_health = clamp(current_health - amount, 0.0, max_health)
	if current_health == 0.0:
		died.emit()
		
func heal(amount: float) -> void:
	current_health = clamp(current_health + amount, 0.0, max_health)
	
