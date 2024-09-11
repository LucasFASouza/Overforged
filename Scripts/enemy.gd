extends CharacterBody2D

@export var speed: int = 20
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var game_manager = $"/root/World/GameManager"

@export var health: int = 50
@onready var health_label: Label = $HealthLabel

var soldiers_infront = []
@onready var soldiers_group = $"/root/World/SoldiersGroup"

var attack_timer: Timer
@export var cooldown: float = 2
@export var damage: int = 3

var mode = "walk"

func _ready() -> void:
	var random_number = randi_range(-10, 10)
	speed += random_number

	health_label.text = str(health)

	attack_timer = Timer.new()
	attack_timer.wait_time = cooldown
	attack_timer.connect("timeout", Callable(self, "attack"))
	add_child(attack_timer)
	attack_timer.start()

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

	if health <= 0:
		soldiers_group.set_mode("idle")
		queue_free()

func attack() -> void:
	if mode == "fight":
		soldiers_group.get_hit(damage)

	attack_timer.start()
