extends Control

@export var lives = 3
@export var wave_timer_time = 90

@onready var health_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var timer_label: Label = $TimerLabel

@onready var enemies_group = $EnemiesGroup
@onready var soldiers_group = $SoldiersGroup

var wave_timer = Timer.new()
var turn_timer = Timer.new()
var finished_wave = false
var phase = "calm"
var mode = "idle"
var turn = "soldiers"
var is_enemy_ready = false
var wave_number = 55


func _ready() -> void:
	wave_timer.wait_time = wave_timer_time
	wave_timer.one_shot = true
	wave_timer.connect("timeout", Callable(self, "_on_wave_timer_timeout"))
	add_child(wave_timer)
	wave_timer.start()

	turn_timer.wait_time = 2
	turn_timer.one_shot = true
	turn_timer.connect("timeout", Callable(self, "combat_step"))
	add_child(turn_timer)

	health_sprite.play(str(lives))

	enemies_group.enemy_ready.connect(on_enemy_ready)


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

	if soldiers_group.get_child_count() == 0 or enemies_group.get_child_count() == 0:
		mode = "idle"

	if soldiers_group.get_child_count() == 0 or not is_enemy_ready:
		enemies_group.set_mode("walk")
	else:
		enemies_group.set_mode("idle")

	if mode == "attack" and turn_timer.is_stopped():
		turn_timer.start()


func get_hit(_damage: int) -> void:
	lives -= 1
	health_sprite.play(str(lives))


func _on_wave_timer_timeout() -> void:
	enemies_group.start_wave(wave_number * 2)
	wave_number += 1
	phase = "battle"

	Audiomanager.play_sfx("warhorn")
	Audiomanager.play_sfx("marchingdrums")
	Audiomanager.switch_music(true)


func finish_wave() -> void:
	finished_wave = true
	phase = "calm"
	wave_timer.wait_time = wave_timer_time + 15
	wave_timer.start()

	Audiomanager.play_sfx("victoryhorns")
	Audiomanager.switch_music(true)


func combat_step() -> void:
	if phase == "battle" and mode == "attack":
		match turn:
			"soldiers":
				if soldiers_group.get_child_count() == 0:
					mode = "idle"
					return

				var soldiers_damage = soldiers_group.attack()
				var enemy_health = enemies_group.get_hit(soldiers_damage)

				if enemy_health <= 0:
					mode = "idle"
					is_enemy_ready = false
					return
				else:
					turn = "enemies"
					turn_timer.start()

			"enemies":
				if enemies_group.get_child_count() == 0:
					mode = "idle"
					return

				var enemy_damage = enemies_group.attack()
				var have_survivors = soldiers_group.get_hit(enemy_damage)

				if not have_survivors:
					mode = "idle"
					enemies_group.set_mode("walk")
					return
				else:
					turn = "soldiers"
					turn_timer.start()
		

func on_enemy_ready() -> void:
	is_enemy_ready = true
	mode = "attack"
