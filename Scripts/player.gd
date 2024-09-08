extends CharacterBody2D

@export var speed: int = 70

var current_direction: String = "front"
var is_moving: bool = false
var animation_name: String = "front_idle"

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var item_sprite: AnimatedSprite2D = $ItemSprite

var item_holding: String = ""


func _physics_process(_delta: float) -> void:
	player_movement()


func player_movement() -> void:	
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		is_moving = true
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		is_moving = true
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = "back"
		is_moving = true
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down"):
		current_direction = "front"
		is_moving = true
		velocity.x = 0
		velocity.y = speed
	else:
		velocity.x = 0
		velocity.y = 0
		is_moving = false
			
	move_and_slide()
	play_animation()


func play_animation() -> void:
	animation_name = current_direction + ("_walk" if is_moving else "_idle")
	player_sprite.play(animation_name)


func get_item(item: String) -> void:
	item_sprite.visible = true
	item_sprite.play(item)
	item_holding = item


func give_item() -> void:
	item_sprite.visible = false
	item_holding = ""


func check_item() -> String:
	return item_holding
