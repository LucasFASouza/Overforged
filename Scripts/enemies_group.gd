extends Node2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

@export var min_spawn_interval: float = 10
@export var max_spawn_interval: float = 15

var spawn_timer: Timer
var enemies_to_spawn: int

@onready var game_manager = get_node("/root/World/GameManager")
var is_attacking = false

func _ready() -> void:
	pass

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
		new_enemy.position = Vector2(150, 0)
		new_enemy.name = "Enemy"
		add_child(new_enemy)
		enemies_to_spawn -= 1
	else:
		game_manager.finish_wave()
		is_attacking = false
