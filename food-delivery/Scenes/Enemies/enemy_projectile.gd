extends Node2D
class_name EnemyProjectile

@export var speed := 1000.0
@export var lifetime := 3.0
@export var damage := 5.0

var direction := Vector2.ZERO

@onready var hitbox: Area2D = $Hitbox
@onready var impact_detector: Area2D = $ImpactDetector
@onready var lifetime_timer: Timer = $LifetimeTimer

func _ready() -> void:
	top_level = true
	look_at(position + direction)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_lifetime_timer_timeout() -> void:
	queue_free()


func _on_impact_detector_body_entered(body: Node2D) -> void:
	if body is WalkingPlayer && !body.is_rolling:
		body.health_component.damage(damage)
		queue_free()
		
func _on_impact_detector_area_entered(area: Area2D) -> void:
	if area is Weapon: 
		var player = area.get_parent().get_parent() as WalkingPlayer
		if player.is_attacking:
			queue_free()
