extends Node2D

var soldier_scene = preload("res://Scenes/soldier.tscn")
var weapons_sold: Array = []

@export var boundary_up: int = -42
@export var boundary_down: int = 56

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func sell_weapon(weapon) -> void:
	weapons_sold.append(weapon)

	var new_soldier = soldier_scene.instantiate()
	new_soldier.name = "Soldier " + str(get_child_count() + 1)
	new_soldier.position = Vector2(35, 90)
	add_child(new_soldier)

	new_soldier.move_to_position(Vector2(35, 0))
