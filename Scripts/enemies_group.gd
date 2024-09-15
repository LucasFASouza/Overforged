extends Node2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

var enemies_to_spawn: int

@onready var game_manager = get_node("/root/World/GameManager")
var is_attacking = false

var mode = "walk"
var min_damage: float
var max_damage: float
var health: float

signal enemy_ready
signal enemy_spawn


func _process(_delta: float) -> void:
	if self.get_child_count() == 0 and is_attacking:
		spawn_enemy()


func start_wave(wave_number: int):
	match wave_number:
		1:
			enemies_to_spawn = 2
			min_damage  = 0.8
			max_damage = 1.4
			health = 4
		2:
			enemies_to_spawn = 4
			min_damage  = 1.4
			max_damage = 2.6
			health = 5
		3:
			enemies_to_spawn = 6
			min_damage  = 2.2
			max_damage = 3.8
			health = 6
	
	var enemies_this_wave = enemies_to_spawn

	is_attacking = true
	spawn_enemy()

	return enemies_this_wave


func spawn_enemy() -> void:
	if enemies_to_spawn > 0:
		var new_enemy = enemy_scene.instantiate()
		new_enemy.position = Vector2(150, 2)
		new_enemy.name = "Enemy"
		new_enemy.min_damage = min_damage
		new_enemy.max_damage = max_damage
		new_enemy.health = health
		add_child(new_enemy)
		
		enemy_spawn.emit()

		new_enemy.position_reached.connect(on_enemy_position_reached)

		new_enemy.move_to_position(Vector2(69, 2))
		enemies_to_spawn -= 1
	else:
		game_manager.finish_wave()
		is_attacking = false


func get_hit(_damage: float):
	if self.get_child_count() > 0:
		var enemy = self.get_child(0)
		var enemy_health = enemy.get_hit(_damage)

		if enemy_health <= 0:
			enemy.die()

		return enemy_health

	else:
		return 0


func attack():
	if self.get_child_count() > 0:
		var enemy = self.get_child(0)
		var damage = enemy.attack()

		return damage


func set_mode(new_mode: String) -> void:
	mode = new_mode

	if self.get_child_count() > 0:
		var child = self.get_child(0)

		if child.mode != "finish":
			child.mode = new_mode


func on_enemy_position_reached():
	get_child(0).move_to_position(Vector2(0, 2))
	enemy_ready.emit()
