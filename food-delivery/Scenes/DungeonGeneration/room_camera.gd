extends Area2D
class_name RoomCamera

@onready var cam: PhantomCamera2D = $PhantomCamera2D

var all_cameras
var roomEnemies : MeleeEnemy

func _ready() -> void:
	all_cameras = get_parent().get_children()

func _on_body_entered(body: Node2D) -> void:
	if body is WalkingPlayer:
		for camera : RoomCamera in all_cameras:
			camera.cam.priority = 0
		cam.priority = 1

func _on_body_exited(body: Node2D) -> void:
	if body is WalkingPlayer:
		cam.priority = 0
