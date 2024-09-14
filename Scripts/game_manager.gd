extends Control

@export var lives = 3
@export var wave_timer_time = 90

@onready var health_sprite: AnimatedSprite2D = $AnimatedSprite2D

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

	health_sprite.play(str(lives))


func _process(_delta: float) -> void:
	if wave_timer.time_left > 0:
		timer_label.text = "Time: " + str(wave_timer.time_left)
	else:
		if lives <= 0:
			timer_label.text = "Game Over"
		else:
			if finished_wave:
				timer_label.text = "You Won!"
			else:
				timer_label.text = "Wave in progress"

func get_hit(_damage: int) -> void:
	lives -= 1
	health_sprite.play(str(lives))

func _on_wave_timer_timeout() -> void:
	enemies_group.start_wave(3)

func finish_wave() -> void:
	finished_wave = true
