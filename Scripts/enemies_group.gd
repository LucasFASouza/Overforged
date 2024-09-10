extends Node2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

@export var boundary_up: int = -42
@export var boundary_down: int = 56

@export var min_spawn_interval: float = 10
@export var max_spawn_interval: float = 15

var spawn_timer: Timer
var enemies_to_spawn: int

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if self.get_child_count() == 0:
		spawn_enemy()

func start_wave(intensity: int) -> void:
	enemies_to_spawn = intensity
	spawn_enemy()

func spawn_enemy() -> void:
	if enemies_to_spawn > 0:
		var new_enemy = enemy_scene.instantiate()
		var y_value = randi_range(boundary_up, boundary_down)
		new_enemy.position = Vector2(150, y_value)
		new_enemy.name = "Enemy"
		add_child(new_enemy)
		enemies_to_spawn -= 1
