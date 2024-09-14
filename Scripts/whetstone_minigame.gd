extends Node2D

@export var stone_speed_up = 30
@export var stone_speed_down = 40

@export var swetspot_speed = 50
var sweetspot_direction = 1

var direction = -1
var is_running = false

@onready var stone: CharacterBody2D = $Stone
var stone_min
var stone_max

@onready var sweetspot: Node2D = $Sweetspot
var sweetspot_min
var sweetspot_max

@onready var sword: Node2D = $Sword
var sword_min
var sword_max

var score: float = 0
var max_score = 0
var phase: int = 1

@export var duration: float = 8
var game_timer: Timer = Timer.new()

@export var movement_duration: float = 1
var movement_timer: Timer = Timer.new()

var whetstone: Node2D

func _ready():
	game_timer.wait_time = duration
	game_timer.one_shot = true
	game_timer.connect("timeout", Callable(self, "stop_minigame"))
	add_child(game_timer)

	movement_timer.wait_time = movement_duration
	movement_timer.one_shot = false
	movement_timer.connect("timeout", Callable(self, "move_sweetspot"))
	add_child(movement_timer)

	whetstone = get_parent()

	sword_min = sword.get_node("MinY").global_position.y
	sword_max = sword.get_node("MaxY").global_position.y

func _physics_process(delta):
	if is_running:
		# Stone movement
		stone_max = stone.get_node("MaxY").global_position.y
		stone_min = stone.get_node("MinY").global_position.y

		if Input.is_action_pressed("interact") and stone_max  > sword_max:
			stone.position += Vector2(0, stone_speed_up * delta * direction)
		elif stone_min < sword_min:
			stone.position += Vector2(0, stone_speed_down * delta * direction * -1)
		
		# Sweetspot movement
		sweetspot_max = sweetspot.get_node("MaxY").global_position.y
		sweetspot_min = sweetspot.get_node("MinY").global_position.y

		if sweetspot_max < sword_max:
			sweetspot_direction = 1
		if sweetspot_min > sword_min:
			sweetspot_direction = -1

		sweetspot.position += Vector2(0, swetspot_speed * delta * sweetspot_direction)

		# Scoring
		if stone_max > sweetspot_max and stone_min < sweetspot_min:
			score += delta
		elif stone_max > sweetspot_max or stone_min < sweetspot_min:
			score += delta/2

		max_score += delta


func move_sweetspot():    
	sweetspot_direction = randi() % 2 * 2 - 1
	swetspot_speed = randf_range(10, 30)
	movement_duration = randf_range(0.8, 1.2)
	movement_timer.wait_time = movement_duration
	movement_timer.start()


func stop_minigame():
	is_running = false
	score = (score / max_score) * 3
	whetstone.finish_minigame(score)
	score = 0
	max_score = 0
	Audiomanager.play_sfx("whetstone", false)


func start_minigame():
	is_running = true

	movement_timer.start()
	game_timer.start()

	score = 0
	max_score = 0

	Audiomanager.play_sfx("whetstone",true)
