extends Control

@export var health = 100
@onready var health_label: Label = $HealthLabel
@onready var timer_label: Label = $TimerLabel
@onready var enemies_group = $"/root/World/EnemiesGroup"

var wave_timer: Timer

func _ready() -> void:
	print(enemies_group)
	wave_timer = Timer.new()
	wave_timer.wait_time = 10.0
	wave_timer.one_shot = true
	wave_timer.connect("timeout", Callable(self, "_on_wave_timer_timeout"))
	add_child(wave_timer)
	wave_timer.start()

func _process(_delta: float) -> void:
	timer_label.text = "Time: " + str(wave_timer.time_left)

func get_hit(damage: int) -> void:
	health -= damage
	health_label.text = "Health: "  + str(health)

	if health <= 0:
		health_label.text = "Game Over"

func _on_wave_timer_timeout() -> void:
	enemies_group.start_wave(5)
