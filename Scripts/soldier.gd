extends CharacterBody2D

@export var speed: int = 50
@onready var soldiers_group = get_parent()
@onready var sprite = $Sprite

var target_position
var is_walking = false

@onready var health_bar: Node2D = $HealthBar
@export var health: float
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var weapon = ItemsType.create_item("")

var die_timer = Timer.new()

func _ready() -> void:
	health_bar.max_health = 3

	print("Minha health é: ", health)

	die_timer.wait_time = 1
	die_timer.one_shot = true
	die_timer.connect("timeout", Callable(self, "queue_free"))
	add_child(die_timer)
	
func _physics_process(_delta: float) -> void:
	entity_movement()

func entity_movement() -> void:
	if is_walking:
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
			velocity.y = 0

			sprite.play("idle")
		
	move_and_slide()

func move_to_position(new_position: Vector2) -> void:
	target_position = new_position
	is_walking = true

func get_hit(damage):
	health -= damage
	health_bar.set_health(health)
	sprite.play("hit")
	return health

func _on_sprite_animation_finished():
	if sprite.animation != 'idle':
		if health > 0:
			sprite.play('idle')

func die():
	sprite.play("die")
	collision_shape_2d.disabled = true
	die_timer.start()
