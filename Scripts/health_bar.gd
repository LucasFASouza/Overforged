extends Node2D

@export var max_health: int = 100
var current_health: int

@onready var progress_bar: TextureProgressBar = $ProgressBar

func _ready() -> void:
	current_health = max_health
	update_health_bar()

func update_health_bar() -> void:
	progress_bar.value = current_health

func set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	update_health_bar()
