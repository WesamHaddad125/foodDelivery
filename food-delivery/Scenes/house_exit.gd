extends Area2D

var house : InnerHouse

func _ready() -> void:
	house = get_parent().get_parent()
	body_entered.connect(house.exit_house)
