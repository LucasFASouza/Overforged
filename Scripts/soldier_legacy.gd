extends CharacterBody2D
@onready var label: Label = $Label

@export var move_interval_min: float = 2.0
@export var move_interval_max: float = 5.0

@export var speed: int = 50

@onready var soldiers_group = get_parent()
@onready var sprite = $Sprite
@onready var sword_sprite: AnimatedSprite2D = $Sword

var target_position: Vector2
var move_timer: Timer
var attack_timer: Timer
@export var attacl_cooldown: float = 1.0

var mode = "idle"

var is_walking = false

@export var soldier_number: int
var weapon = ItemsType.create_item("")

var enemy_locked: Node2D
@onready var enemies_group = $/root/World/EnemiesGroup

func _ready() -> void:
	target_position = Vector2(35, 50)
	is_walking = true

	move_timer = Timer.new()
	move_timer.wait_time = randf_range(move_interval_min, move_interval_max)
	move_timer.connect("timeout", Callable(self, "_on_move_timer_timeout"))
	add_child(move_timer)

	attack_timer = Timer.new()
	attack_timer.wait_time = attacl_cooldown
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	add_child(attack_timer)
	

func _physics_process(_delta: float) -> void:
	label.text = mode

	if enemies_group.get_child_count() > 0 and not enemy_locked:
		var enemy = enemies_group.get_child(0)
		var enemy_position = enemy.position
		target_position.y = enemy_position.y

	entity_movement()

func _on_move_timer_timeout() -> void:
	move_randomly()	

func _on_attack_timer_timeout() -> void:
	if enemy_locked:
		enemy_locked.get_hit(weapon.whetstone_level)

func entity_movement() -> void:
	if is_walking:
		sword_sprite.visible = false
		var direction = (target_position - position).normalized()
		velocity.x = 0

		if direction.y > 0:
			sprite.play("front_walk")
			velocity.y = speed
		elif direction.y < 0:
			sprite.play("back_walk")
			velocity.y = -speed

		if position.distance_to(target_position) < 1:
			is_walking = false
			sword_sprite.visible = true
			velocity.y = 0
			sprite.play("idle")

			if mode == "idle":
				move_timer.wait_time = randf_range(move_interval_min, move_interval_max)
				move_timer.start()
		
	move_and_slide()

func move_randomly() -> void:
	if enemy_locked:
		return

	move_timer.stop()

	var y_range = soldiers_group.boundary_down - soldiers_group.boundary_up

	var sector_height = y_range / soldiers_group.soldiers_count

	soldier_number = soldiers_group.get_soldier_number(self)

	var sector_start = soldiers_group.boundary_up + (sector_height * soldier_number)
	var sector_end = sector_start + sector_height
	
	target_position.y = randi_range(sector_start, sector_end)

	is_walking = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name.split(" ")[0] == "Enemy":
		enemy_locked = body
		is_walking = false
		move_timer.stop()
		sprite.play("idle")
		mode = "attack"
		attack_timer.start()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == enemy_locked:
		enemy_locked = null
		velocity.y = 0
		mode = "idle"
		move_randomly()

# OK SO NEW IDEA
# rework this whole thing, and make the main component be soldier group instead of soldier
# the group will match the enemies or divide itself, but each soldier won't decide where to go
# calculate the damage based on each weapon
