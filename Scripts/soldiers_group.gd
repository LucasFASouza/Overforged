extends Node2D

var soldier_scene = preload("res://Scenes/soldier.tscn")
var weapons_sold: Array = []

@export var boundary_up: int = -55
@export var boundary_down: int = 60

@export var damage: float = 0


func attack():
	damage = 0

	for child in get_children():        
		child.sprite.play("attack")
		damage += child.weapon.whetstone_level
	
	return damage
	

func sell_weapon(weapon) -> void:
	weapons_sold.append(weapon)

	var new_soldier = soldier_scene.instantiate()
	new_soldier.name = "Soldier " + str(get_child_count())
	new_soldier.position = Vector2(35, 90)
	new_soldier.health = weapon.anvil_level
	new_soldier.weapon = weapon

	add_child(new_soldier)

	# new_soldier.position_reached.connect(on_soldier_position_reached)

	move_soldiers()


func move_soldiers():
	Audiomanager.play_sfx("soldierfootsteps")
	var soldiers = get_children()
	var soldiers_count = soldiers.size()

	for i in range(soldiers_count):
		var soldier = soldiers[i]

		if soldier.health < 0:
			continue

		var new_position = Vector2(35, boundary_up + (boundary_down - boundary_up) / (soldiers_count + 1) * (i + 1))

		soldier.move_to_position(new_position)


func get_hit(damage_hit: float):
	var damage_left: float = damage_hit
	var have_survivors = false

	for child in get_children():
		child.get_hit(damage_left)

		if child.health < 0:
			child.die()
			damage_left = abs(child.health)
		else:
			have_survivors = true
			break

	move_soldiers()
	return have_survivors
