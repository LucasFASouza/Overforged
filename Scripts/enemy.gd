extends CharacterBody2D

@export var speed: int = 20
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var game_manager = get_node("/root/World/GameManager")

@export var health: int = 5
@onready var health_label: Label = $HealthLabel

var soldiers_infront = []

func _ready() -> void:
	var random_number = randi_range(-10, 10)
	speed += random_number

func _physics_process(_delta: float) -> void:
	entity_movement()

	if health <= 0:
		queue_free()

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

	elif body.name.split(" ")[0] == "Soldier":
		soldiers_infront.append(body)

		if soldiers_infront.size() > 1:
			speed = 0
			sprite.play("idle")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name.split(" ")[0] == "Soldier":
		soldiers_infront.erase(body)

		if soldiers_infront.size() == 0:
			speed = 20
			sprite.play("walk")

func get_hit(damage: int) -> void:
	print("Enemy got hit")
	health -= damage
	health_label.text = str(health)
