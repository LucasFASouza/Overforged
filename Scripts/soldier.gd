extends CharacterBody2D

@export var move_interval_min: float = 2.0
@export var move_interval_max: float = 5.0

@export var speed: int = 50

@onready var soldiers_group = get_parent()
@onready var sprite = $Sprite
@onready var sword_sprite: AnimatedSprite2D = $Sword

var target_position: Vector2
var move_timer: Timer

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
	

func _physics_process(_delta: float) -> void:
	print("Locked: ", enemy_locked)
	print("Target: ", target_position)
	print("Position: ", position)

	entity_movement()
	get_closest_enemy()


func _on_move_timer_timeout() -> void:
	move_randomly()	


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
			sprite.play("right_idle")

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


func get_closest_enemy():
	var closest_enemy = null
	var closest_distance = 1000000

	for enemy_i in enemies_group.get_children():
		if enemy_i.name == "SpawnTimer":
			continue

		var distance = position.distance_to(enemy_i.position)

		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy_i
	
	if closest_enemy:
		target_position.y = closest_enemy.position.y
		is_walking = true
		enemy_locked = closest_enemy
	else:
		enemy_locked = null


# TODO: Rework movement
# make soldier be able to move a little to the right also
# only 1 enemy will spanw at time
# make a pathfind until this enemy
# when close enough, start attacking every cooldown