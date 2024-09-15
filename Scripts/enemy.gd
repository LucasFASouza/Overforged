extends CharacterBody2D

@export var speed: int = 20
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var game_manager = $"/root/World/GameManager"

@export var health: float = 4
@onready var health_bar: Node2D = $HealthBar

@export var min_damage: float = 1
@export var max_damage: float = 4

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

	if mode == "walk" and self.global_position.x < 36:
		mode = "finish"

		game_manager.get_hit()

		sprite.play("attack")
		Audiomanager.play_sfx("houseattacked")
		
		health = 0
		health_bar.visible = false


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


func get_hit(damage_hit: float):
	health -= damage_hit
	health_bar.set_health(health)

	sprite.play("hit")

	return health


func attack():
	var attack_damage = randf_range(min_damage, max_damage)

	sprite.play("attack")
	Audiomanager.play_sfx("enemyattack")
	
	return attack_damage


func die():
	sprite.play("die")
	Audiomanager.play_sfx("enemydying")
	health_bar.visible = false


func _on_sprite_animation_finished():
	if sprite.animation != 'idle' and health > 0:
		sprite.play('idle')
	elif health <= 0:
		queue_free()
	pass
