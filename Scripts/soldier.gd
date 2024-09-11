extends CharacterBody2D

@export var speed: int = 50
@onready var soldiers_group = get_parent()
@onready var sprite = $Sprite

var target_position
var is_walking = false

@onready var health_label = $HealthLabel
@export var health: int = 0

func _ready() -> void:
	health_label.text = str(health)
	
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
	
	if soldiers_group.mode == "fight":
		sprite.play("hit")
		
	move_and_slide()

func move_to_position(new_position: Vector2) -> void:
	target_position = new_position
	is_walking = true

func get_hit(damage):
	health -= damage
	health_label.text = str(health)
	return health
