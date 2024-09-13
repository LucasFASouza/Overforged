extends Node2D

@export var basic_speed = 50
var speed = basic_speed
var direction = -1
var is_running = false

@onready var hammer: CharacterBody2D = $Hammer
var hammer_min
var hammer_max

@onready var sweetspot: Node2D = $Sweetspot
var sweetspot_min
var sweetspot_max

@onready var sword: Node2D = $Sword
var sword_min
var sword_max

var score: float = 0
var phase: int = 1

var restart_timer: Timer
var delay_timer: Timer
var anvil: Node2D

func _ready():
	restart_timer = Timer.new()
	restart_timer.wait_time = 2
	restart_timer.one_shot = true
	restart_timer.connect("timeout", Callable(self, "start_minigame"))
	add_child(restart_timer)
	
	delay_timer = Timer.new()
	delay_timer.wait_time = 0.01
	delay_timer.one_shot = true
	delay_timer.connect("timeout", Callable(self, "start_running_delayed"))
	add_child(delay_timer)

	anvil = get_parent()

func _physics_process(delta):
	if is_running:
		hammer.position += Vector2(speed * delta * direction * -1, 0)
		
		if Input.is_action_just_pressed("interact"):
			stop_hammer()
			Audiomanager.play_sfx("anvil")

func _on_min_x_body_entered(_body: Node2D) -> void:
	direction = -1

func _on_max_x_body_entered(_body: Node2D) -> void:
	direction = 1

func start_minigame():
	match phase:
		1:
			speed = basic_speed
			sweetspot.scale.x = 1
		2:
			speed += 20
			sweetspot.scale.x = 0.75
		3:
			speed += 20
			sweetspot.scale.x = 0.5
		4:
			anvil.finish_minigame(score)
			score = 0
			phase = 1
			is_running = false

			return
	
	sword_min = sword.get_node("MinX").global_position.x
	sword_max = sword.get_node("MaxX").global_position.x
	var random_x = randf_range(sword_min, sword_max)
	sweetspot.global_position.x = random_x
	delay_timer.start()
	anvil.player.player_sprite.play("back_idle")

func stop_hammer():
	is_running = false

	sweetspot_min = sweetspot.get_node("MinX").global_position.x
	sweetspot_max = sweetspot.get_node("MaxX").global_position.x
	
	hammer_min = hammer.get_node("MinX").global_position.x
	hammer_max = hammer.get_node("MaxX").global_position.x
	
	if hammer_min >= sweetspot_min and hammer_max <= sweetspot_max:
		score += 1
	elif hammer_min >= sweetspot_min or hammer_max <= sweetspot_max:
		score += 0.5
	else:
		score += 0

	phase += 1
	restart_timer.start()
	anvil.player.player_sprite.play("back_hammer")
		

func start_running_delayed():
	is_running = true
