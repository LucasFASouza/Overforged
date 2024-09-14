extends CharacterBody2D

@export var speed: int = 20
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var game_manager = $"/root/World/GameManager"

@export var health: float = 15
@onready var health_bar: Node2D = $HealthBar

@export var damage: int = 3

var mode = "walk"
var target_position

signal position_reached


func _ready() -> void:
	var random_number = randi_range(-10, 10)
	speed += random_number

	health_bar.max_health = health
	health_bar.set_health(health)


func _physics_process(_delta: float) -> void:
	entity_movement()


func entity_movement() -> void:
	velocity.y = 0	
	if mode == "walk":
		velocity.x = -speed
		sprite.play("walk")

		if position.distance_to(target_position) < 1:
			mode = "idle"
			velocity.x = 0

			sprite.play("idle")
			position_reached.emit()

	move_and_slide()


func move_to_position(new_position: Vector2) -> void:
	target_position = new_position
	mode = "walk"


func _on_area_2d_body_entered(body: Node2D) -> void:
	# TODO: Change for check the position
	if body.name == "TileMap":
		game_manager.get_hit(10)
		queue_free()


func get_hit(damage_hit: int):
	health -= damage_hit
	health_bar.set_health(health)

	sprite.play("hit")

	return health


func attack():
	damage = randf_range(1, 3)

	sprite.play("attack")

	return damage


func die():
	sprite.play("die")
	health_bar.visible = false


func _on_sprite_animation_finished():
	if sprite.animation != 'idle' and health > 0:
		sprite.play('idle')
	elif sprite.animation == 'die':
		queue_free()
	pass
