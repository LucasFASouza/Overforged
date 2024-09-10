extends Node2D

var soldier_scene = preload("res://Scenes/soldier.tscn")
var weapons_sold: Array = []

@export var boundary_up: int = -46
@export var boundary_down: int = 60

var enemy: Node2D

var mode = "idle"
var attack_timer: Timer
@export var cooldown: float = 2
@export var damage: int = 0

func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.wait_time = cooldown
	attack_timer.connect("timeout", Callable(self, "attack"))
	add_child(attack_timer)
	attack_timer.start()

func attack() -> void:
	if mode == "fight":
		damage = 0

		for weapon in weapons_sold:
			damage += weapon.whetstone_level

		enemy.get_hit(damage)
	
	attack_timer.start()	

func sell_weapon(weapon) -> void:
	weapons_sold.append(weapon)

	var new_soldier = soldier_scene.instantiate()
	new_soldier.name = "Soldier " + str(get_child_count() + 1)
	new_soldier.position = Vector2(35, 90)
	new_soldier.health = weapon.anvil_level
	add_child(new_soldier)

	move_soldiers()

func move_soldiers():
	var soldiers = get_children()
	var soldiers_count = soldiers.size()

	for i in range(soldiers_count):
		var soldier = soldiers[i]

		if soldier.name.split(" ")[0] != "Soldier":
			continue
		
		var new_position = Vector2(35, boundary_up + (boundary_down - boundary_up) / (soldiers_count + 1) * (i + 1))

		soldier.move_to_position(new_position)

		print(soldier.name + " moved to " + str(new_position))

func get_hit(damage_hit):
	var first_soldier: Node2D

	for child in get_children():
		if child.name.split(" ")[0] != "Soldier":
			continue

		first_soldier = child

	var soldier_health = first_soldier.get_hit(damage_hit)

	if soldier_health <= 0:
		first_soldier.queue_free()
		move_soldiers()

func set_mode(new_mode):
	for soldier in get_children():
		if soldier.name.split(" ")[0] != "Soldier":
			continue

		soldier.mode = new_mode

	mode = new_mode

	if new_mode == "idle":
		enemy = null
		move_soldiers()
