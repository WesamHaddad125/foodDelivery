extends Area2D
class_name UpgradeNode

@export var upgrade : Upgrade
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.texture = upgrade.texture
	
func _on_body_entered(body: Node2D) -> void:
	if body is WalkingPlayer:
		body.gain_upgrade(upgrade)
		
	call_deferred("queue_free")
