extends Node2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

var spawn_timer: Timer = Timer.new()
var enemies_to_spawn: int

@onready var game_manager = get_node("/root/World/GameManager")
var is_attacking = false

func _ready() -> void:
	spawn_timer.connect("timeout", Callable(self, "spawn_enemy"))
	spawn_timer.wait_time = 1
	spawn_timer.one_shot = true
	add_child(spawn_timer)

func _process(_delta: float) -> void:
	if self.get_child_count() == 1 and is_attacking and spawn_timer.is_stopped():
		spawn_timer.wait_time = randf_range(1, 4)
		spawn_timer.start()

func start_wave(intensity: int) -> void:
	enemies_to_spawn = intensity
	is_attacking = true
	spawn_timer.start()

func spawn_enemy() -> void:
	if enemies_to_spawn > 0:
		var new_enemy = enemy_scene.instantiate()
		new_enemy.position = Vector2(150, 16)
		new_enemy.name = "Enemy"
		add_child(new_enemy)
		enemies_to_spawn -= 1
	else:
		game_manager.finish_wave()
		is_attacking = false
