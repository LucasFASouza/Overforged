extends CharacterBody2D

@export var speed: int = 50
@onready var sprite = $Sprite

var target_position
var mode = "idle"

@onready var health_bar: Node2D = $HealthBar
@export var health: float

var weapon = ItemsType.create_item("")

signal position_reached

func _ready() -> void:
	health_bar.max_health = 3
	health_bar.update_health_bar()

	
func _physics_process(_delta: float) -> void:
	entity_movement()


func entity_movement() -> void:
	velocity.x = 0 
	if mode == "walk":
		var direction = (target_position - position).normalized()
		var animation_direction

		if direction.y > 0:
			animation_direction = "front"
			velocity.y = speed
		elif direction.y < 0:
			animation_direction = "back"
			velocity.y = -speed

		if sprite.animation == "idle":
			sprite.play(animation_direction + "_walk")

		if position.distance_to(target_position) < 1:
			mode = "idle"

			if sprite.animation == animation_direction + "_walk":
				sprite.play("idle")

			velocity.y = 0

			position_reached.emit()
		
	move_and_slide()


func move_to_position(new_position: Vector2) -> void:
	target_position = new_position
	mode = "walk"


func get_hit(damage):
	health -= damage
	health_bar.set_health(health)
	sprite.play("hit")
	return health


func die():
	sprite.stop()
	sprite.play("die")
	health_bar.visible = false
	health_bar.set_health(0)
	health = 0
	$CollisionShape2D.disabled = true


func _on_sprite_animation_finished():
	if sprite.animation != 'idle' and health > 0:
		sprite.play('idle')
	elif sprite.animation == 'die':
		queue_free()
	pass
