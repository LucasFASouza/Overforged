extends CharacterBody2D

@export var speed: int = 20
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var game_manager = $"/root/World/GameManager"

@export var health: float = 15
@onready var health_label: Label = $HealthLabel

var soldiers_infront = []
@onready var soldiers_group = $"/root/World/SoldiersGroup"

var attack_timer = Timer.new()
@export var cooldown: float = 2
@export var damage: int = 3

var die_timer = Timer.new()

var mode = "walk"

func _ready() -> void:
	var random_number = randi_range(-10, 10)
	speed += random_number

	health_label.text = str(health)

	attack_timer.wait_time = cooldown
	attack_timer.connect("timeout", Callable(self, "attack"))
	add_child(attack_timer)
	attack_timer.start()

	die_timer.wait_time = 1
	die_timer.one_shot = true
	die_timer.connect("timeout", Callable(self, "queue_free"))
	add_child(die_timer)

func _physics_process(_delta: float) -> void:
	entity_movement()

	if health <= 0:
		soldiers_group.set_mode("idle")
		queue_free()

func entity_movement() -> void:
	velocity.y = 0
	if mode == "walk":
		velocity.x = -speed
		sprite.play("walk")
	else:
		velocity.x = 0
		sprite.play("idle")

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		game_manager.get_hit(10)
		queue_free()

	elif body.name.split(" ")[0] == "Soldier":
		soldiers_infront.append(body)

		soldiers_group.set_mode("fight")
		soldiers_group.enemy = self
		mode = "fight"

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name.split(" ")[0] == "Soldier":
		soldiers_infront.erase(body)

func get_hit(damage_hit: int) -> void:
	health -= damage_hit
	health_label.text = str(health)

	sprite.play("hit")

	if health <= 0:
		soldiers_group.set_mode("idle")
		sprite.play("die")

func attack() -> void:
	if mode == "fight":
		damage = randf_range(1, 3)
		soldiers_group.get_hit(damage)
		sprite.play("attack")

	attack_timer.start()

func _on_sprite_animation_finished():
	if sprite.animation != 'idle':
		if health > 0:
			sprite.play('idle')
