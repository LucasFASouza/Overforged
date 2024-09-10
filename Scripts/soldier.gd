extends CharacterBody2D

@export var speed: int = 50
@onready var soldiers_group = get_parent()
@onready var sprite = $Sprite

var target_position
var is_walking = false

func _ready() -> void:
	pass
	
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
