extends CharacterBody2D

@export var move_interval_min: float = 2.0
@export var move_interval_max: float = 5.0

@export var speed: int = 50

@onready var soldiers_group = get_parent()
@onready var sprite = $PlayerSprite
@onready var sword_sprite: AnimatedSprite2D = $Sword

@onready var boundary_up = $"/root/World/BoundaryUp"
@onready var boundary_down = $"/root/World/BoundaryDown"

var target_position: Vector2
var move_timer: Timer

var is_walking = false

@export var soldier_number: int
var weapon = ItemsType.create_item("")

func _ready() -> void:
	target_position = Vector2(40, 50)
	is_walking = true

	move_timer = Timer.new()
	move_timer.wait_time = lerp(move_interval_min, move_interval_max, randf())
	move_timer.connect("timeout", Callable(self, "_on_move_timer_timeout"))
	add_child(move_timer)
	
func _physics_process(_delta: float) -> void:
	entity_movement()

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

			move_timer.wait_time = lerp(move_interval_min, move_interval_max, randf())
			move_timer.start()
	
	move_and_slide()

func move_randomly() -> void:
	move_timer.stop()

	var y_range = boundary_down.position.y - boundary_up.position.y

	var sector_height = y_range / soldiers_group.soldiers_count

	soldier_number = soldiers_group.get_soldier_number(self)

	var sector_start = boundary_up.position.y + (sector_height * soldier_number)
	var sector_end = sector_start + sector_height
	
	target_position.y = lerp(sector_start, sector_end, randf())

	is_walking = true
