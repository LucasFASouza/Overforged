extends Node2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

@export var boundary_up: int = -42
@export var boundary_down: int = 56

@export var min_spawn_interval: float = 0.2
@export var max_spawn_interval: float = 2

var spawn_timer: Timer
var enemies_to_spawn: int

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)

func start_wave(intensity: int) -> void:
	enemies_to_spawn = intensity
	spawn_enemy()

func spawn_enemy() -> void:
	if enemies_to_spawn > 0:
		var new_enemy = enemy_scene.instantiate()
		var y_value = randi_range(boundary_up, boundary_down)
		new_enemy.position = Vector2(150, y_value)
		add_child(new_enemy)
		enemies_to_spawn -= 1

		var interval = randf_range(min_spawn_interval, max_spawn_interval)
		spawn_timer.start(interval)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
