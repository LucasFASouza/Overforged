extends Node2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

var enemies_to_spawn: int

@onready var game_manager = get_node("/root/World/GameManager")
var is_attacking = false

var mode = "walk"
var damage: float
var health: float
var speed: float

signal enemy_ready
signal enemy_spawn


func _process(_delta: float) -> void:
	if self.get_child_count() == 0 and is_attacking:
		spawn_enemy()


func start_wave(wave_number: int):
	match wave_number:
		1:
			enemies_to_spawn = 2
			damage  = 1
			health = 4
			speed = 20
		2:
			enemies_to_spawn = 4
			damage  = 1.5
			health = 5
			speed = 22
		3:
			enemies_to_spawn = 6
			damage  = 2.5
			health = 6
			speed = 25
	
	var enemies_this_wave = enemies_to_spawn

	is_attacking = true
	spawn_enemy()

	return enemies_this_wave


func spawn_enemy() -> void:
	if enemies_to_spawn > 0:
		var new_enemy = enemy_scene.instantiate()
		new_enemy.position = Vector2(150, 14)
		new_enemy.name = "Enemy"
		new_enemy.damage = damage
		new_enemy.health = health
		new_enemy.speed = speed
		add_child(new_enemy)
		
		enemy_spawn.emit()

		new_enemy.position_reached.connect(on_enemy_position_reached)

		new_enemy.move_to_position(Vector2(69, 14))
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
		var damage_dealt = enemy.attack()

		return damage_dealt


func set_mode(new_mode: String) -> void:
	mode = new_mode

	if self.get_child_count() > 0:
		var child = self.get_child(0)

		if child.mode != "finish":
			child.mode = new_mode


func on_enemy_position_reached():
	get_child(0).move_to_position(Vector2(0, 2))
	enemy_ready.emit()
