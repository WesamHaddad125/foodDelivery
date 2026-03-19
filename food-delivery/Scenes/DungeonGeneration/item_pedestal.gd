extends Node2D

var floatTween : Tween
var fadeTween : Tween
var initalPos 
@onready var pedestal_sprite: Sprite2D = $PedestalSprite
@onready var item_sprite: Sprite2D = $ItemSprite
@onready var weapon_label: Label = $WeaponLabel
var player_data : PlayerData = preload("res://Scenes/Resources/player_data.tres")

@export var weaponOptions : Array[Resource]
var startingWeapon : Resource
var weaponObj : Weapon

func _ready() -> void:
	startingWeapon = weaponOptions.filter(func(weapon): return weapon != player_data.currWeapon).pick_random()
	weaponObj = startingWeapon.instantiate()
	if floatTween:
		floatTween.kill()
	initalPos = item_sprite.global_position
	item_sprite.texture = weaponObj.texture
	weapon_label.text = weaponObj.weapon_name
	weapon_label.modulate.a = 0.0
	floatTween = create_tween()
	floatTween.set_loops()
	floatTween.tween_property(item_sprite, "global_position:y", initalPos.y + randi_range(2,5), 0.8)
	floatTween.tween_property(item_sprite, "global_position:y", initalPos.y - randi_range(2,5), 0.8)


func _on_item_text_display_body_entered(body: Node2D) -> void:
	if body is WalkingPlayer:
		if fadeTween:
			fadeTween.kill()
		fadeTween = create_tween()
		fadeTween.tween_property(weapon_label, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE)

func _on_item_text_display_body_exited(body: Node2D) -> void:
	if body is WalkingPlayer:
		if fadeTween:
			fadeTween.kill()
		fadeTween = create_tween()
		fadeTween.tween_property(weapon_label, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_SINE)


func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is WalkingPlayer:
		var tempWeapon := weaponObj
		weaponObj = body.currentWeapon.duplicate()
		body.replace_weapon(tempWeapon)
		item_sprite.texture = weaponObj.texture
		weapon_label.text = weaponObj.weapon_name
		
