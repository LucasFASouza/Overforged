extends CharacterBody2D

@export var speed: int = 20
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var game_manager = get_node("/root/World/GameManager")

func _ready() -> void:
	var random_number = randi_range(-10, 10)
	speed += random_number

func _physics_process(_delta: float) -> void:
	entity_movement()

func entity_movement() -> void:
	velocity.y = 0
	velocity.x = -speed

	if velocity.x != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		game_manager.get_hit(10)
		queue_free()
