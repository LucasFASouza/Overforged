extends Node2D

var soldier_scene = preload("res://Scenes/soldier.tscn")

var soldiers_count: int = 0
var weapons_sold: Array = []

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	soldiers_count = get_child_count()

func sell_weapon(weapon) -> void:
	weapons_sold.append(weapon)
	soldiers_count += 1

	var new_soldier = soldier_scene.instantiate()
	new_soldier.name = "Soldier " + str(soldiers_count)
	new_soldier.position = Vector2(40, 90)
	new_soldier.weapon = weapon
	add_child(new_soldier)

	for i in range(get_child_count()):
		var soldier = get_child(i)

		if i != get_child_count() - 1:
			soldier.move_randomly()

func get_soldier_number(soldier) -> int:
	for i in range(get_child_count()):
		if get_child(i) == soldier:
			return i

	return -1
