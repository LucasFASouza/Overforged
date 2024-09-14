extends Node2D

@export var max_health: float = 3
var current_health: float

@onready var progress_bar: TextureProgressBar = $ProgressBar

func _ready() -> void:
	current_health = max_health
	update_health_bar()

func update_health_bar() -> void:
	progress_bar.max_value = max_health
	progress_bar.value = current_health

func set_health(value: float) -> void:
	current_health = clamp(value, 0, max_health)
	update_health_bar()
