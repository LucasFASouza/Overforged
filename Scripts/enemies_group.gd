extends Node2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

var enemies_to_spawn: int

@onready var game_manager = get_node("/root/World/GameManager")
var is_attacking = false

var mode = "walk"

signal enemy_ready


func _process(_delta: float) -> void:
	if self.get_child_count() == 0 and is_attacking:
		spawn_enemy()


func start_wave(intensity: int) -> void:
	enemies_to_spawn = intensity
	is_attacking = true
	spawn_enemy()


func spawn_enemy() -> void:
	if enemies_to_spawn > 0:
		var new_enemy = enemy_scene.instantiate()
		new_enemy.position = Vector2(150, 2)
		new_enemy.name = "Enemy"
		add_child(new_enemy)

		new_enemy.position_reached.connect(on_enemy_position_reached)

		new_enemy.move_to_position(Vector2(69, 2))
		enemies_to_spawn -= 1
	else:
		game_manager.finish_wave()
		is_attacking = false


func get_hit(_damage: int):
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
		var enemy = self.get_child(0)
		enemy.mode = new_mode


func on_enemy_position_reached():
	get_child(0).move_to_position(Vector2(0, 2))
	emit_signal("enemy_ready")
