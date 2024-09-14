extends Node2D

var soldier_scene = preload("res://Scenes/soldier.tscn")
var weapons_sold: Array = []

@export var boundary_up: int = -55
@export var boundary_down: int = 60

var enemy: Node2D

var mode = "idle"
@export var damage: int = 0

func _process(_delta: float) -> void:
	if enemy == null:
		mode = "idle"

func attack() -> void:
	if mode == "fight" and get_child_count() > 0:
		damage = 0

		for child in get_children():
			if child.name.split(" ")[0] != "Soldier":
				continue
			
			child.sprite.play("attack")
			damage += child.weapon.whetstone_level
		
		enemy.get_hit(damage)
	
		attack_timer.start()	

func sell_weapon(weapon) -> void:
	weapons_sold.append(weapon)

	var new_soldier = soldier_scene.instantiate()
	new_soldier.name = "Soldier " + str(get_child_count())
	new_soldier.position = Vector2(35, 90)
	new_soldier.health = weapon.anvil_level
	new_soldier.weapon = weapon

	add_child(new_soldier)

	if enemy != null:
		enemy.mode = "fight"

	move_soldiers()

func move_soldiers():
	Audiomanager.play_sfx("soldierfootsteps")
	var soldiers = get_children()
	var soldiers_count = soldiers.size()

	for i in range(soldiers_count):
		var soldier = soldiers[i]

		if soldier.name.split(" ")[0] != "Soldier":
			continue
		
		var new_position = Vector2(35, boundary_up + (boundary_down - boundary_up) / (soldiers_count + 1) * (i + 1))

		soldier.move_to_position(new_position)

func get_hit(damage_hit):
	var first_soldier: Node2D

	for child in get_children():
		if child.name.split(" ")[0] != "Soldier":
			continue
		first_soldier = child
		break

	if first_soldier == null:
		enemy.mode = "walk"
		return

	var soldier_health = first_soldier.get_hit(damage_hit)

	if soldier_health <= 0:
		first_soldier.name = "Dead Guy"
		first_soldier.die()
		call_deferred("_handle_remaining_damage", soldier_health * -1)
		
func _handle_remaining_damage(remaining_damage):
	if get_child_count() == 1:
		enemy.mode = "walk"
	else:
		move_soldiers()
		get_hit(remaining_damage)

func set_mode(new_mode):
	mode = new_mode

	if new_mode == "idle":
		enemy = null
		move_soldiers()
	else:
		attack_timer.start()
