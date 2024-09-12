extends Control

@export var health = 10
@export var wave_timer_time = 20

@onready var health_label: Label = $HealthLabel
@onready var timer_label: Label = $TimerLabel
@onready var enemies_group = $"/root/World/EnemiesGroup"

var wave_timer: Timer
var finished_wave = false

func _ready() -> void:
	wave_timer = Timer.new()
	wave_timer.wait_time = wave_timer_time
	wave_timer.one_shot = true
	wave_timer.connect("timeout", Callable(self, "_on_wave_timer_timeout"))
	add_child(wave_timer)
	wave_timer.start()

func _process(_delta: float) -> void:
	if wave_timer.time_left > 0:
		timer_label.text = "Time: " + str(wave_timer.time_left)
	else:
		if health <= 0:
			timer_label.text = "Game Over"
		else:
			if finished_wave:
				timer_label.text = "You Won!"
			else:
				timer_label.text = "Wave in progress"

func get_hit(damage: int) -> void:
	health -= damage
	health_label.text = "Health: "  + str(health)

func _on_wave_timer_timeout() -> void:
	enemies_group.start_wave(5)

func finish_wave() -> void:
	finished_wave = true
