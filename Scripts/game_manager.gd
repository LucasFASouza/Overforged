extends Control

@export var lives = 3

@onready var health_sprite: AnimatedSprite2D = $LivesHUD
@onready var counter_sprite: AnimatedSprite2D = $CounterHUD

@onready var counter_label: Label = $CounterLabel

@onready var enemies_group = $EnemiesGroup
@onready var soldiers_group = $SoldiersGroup

var wave_timer = Timer.new()
var turn_timer = Timer.new()
var finished_wave = false

var phase = "calm"
var mode = "idle"
var turn = "enemies"

var is_enemy_ready = false
var wave_number = 0
var enemies_coming = 0

var ending_scene = preload("res://Scenes/endgamescreen.tscn")


func _ready() -> void:
	wave_timer.wait_time = 60
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
	enemies_group.enemy_spawn.connect(on_enemy_spawn)


func _process(_delta: float) -> void:
	if wave_timer.time_left > 0:
		counter_label.text = str(int(wave_timer.time_left))
		counter_sprite.play("time")
	else:
		counter_label.text = str(enemies_coming)
		counter_sprite.play("enemies")

	if soldiers_group.get_child_count() == 0 or enemies_group.get_child_count() == 0:
		mode = "idle"

	if soldiers_group.get_child_count() == 0 or not is_enemy_ready:
		enemies_group.set_mode("walk")
	else:
		enemies_group.set_mode("idle")

	if mode == "attack" and turn_timer.is_stopped():
		turn_timer.start()


func get_hit(_damage: float) -> void:
	lives -= 1
	health_sprite.play(str(lives))

	if lives == 0:
		phase = "defeat"
		Audiomanager.switch_music("defeat")

		var new_scene = ending_scene.instantiate()
		get_tree().root.add_child(new_scene)
		get_tree().current_scene.queue_free() 
		get_tree().current_scene = new_scene
		new_scene.change_endscreen_text("You lost", "result")


func _on_wave_timer_timeout() -> void:
	wave_number += 1
	enemies_coming = enemies_group.start_wave(wave_number)
	phase = "battle"

	Audiomanager.play_sfx("warhorn")
	Audiomanager.switch_music("battle")


func finish_wave() -> void:
	Audiomanager.play_sfx("victoryhorn")
	finished_wave = true

	if wave_number < 3:
		phase = "calm"
		wave_timer.wait_time = 60
		wave_timer.start()

		Audiomanager.switch_music("main")
	
	else:
		phase = "victory"
		Audiomanager.switch_music("victory")

		var new_scene = ending_scene.instantiate()
		get_tree().root.add_child(new_scene)
		get_tree().current_scene.queue_free() 
		get_tree().current_scene = new_scene 


func combat_step() -> void:
	if phase == "battle" and mode == "attack":
		match turn:
			"soldiers":
				if soldiers_group.get_child_count() == 0:
					mode = "idle"
					return

				var soldiers_damage = soldiers_group.attack()
				var enemy_health = enemies_group.get_hit(soldiers_damage)

				turn = "enemies"

				if enemy_health <= 0:
					enemies_coming -= 1
					mode = "idle"
					return
				else:
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


func on_enemy_spawn() -> void:
	is_enemy_ready = false
	mode = "idle"
