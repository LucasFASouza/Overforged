extends CharacterBody2D

@export var speed: int = 70

var current_direction: String = "front"
var is_moving: bool = false
var animation_name: String = "front_idle"

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var item_sprite: AnimatedSprite2D = $ItemSprite

var item_holding = ItemsType.create_item("")
const dropped_item_scene = preload("res://Scenes/dropped_item.tscn")

var current_interactable_item = null
var items_in_range = []

var state: String = 'free'

func _physics_process(_delta: float) -> void:
	player_movement()

	current_interactable_item = get_closest_interactable_item()

	if state == 'free':
		if Input.is_action_just_pressed("interact"):
			if current_interactable_item != null:
				current_interactable_item.interact()
		if Input.is_action_just_pressed("drop"):
			drop_item()
		

func player_movement() -> void:    
	if state != 'free':
		return

	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1

	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1

	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		is_moving = true

		# Determine the current direction based on the input vector
		if abs(input_vector.x) >= abs(input_vector.y):
			current_direction = "right" if input_vector.x > 0 else "left"
		else:
			current_direction = "back" if input_vector.y < 0 else "front"
	else:
		velocity = Vector2.ZERO
		is_moving = false
			
	move_and_slide()
	play_animation()

func play_animation() -> void:
	animation_name = current_direction + ("_walk" if is_moving else "_idle")
	player_sprite.play(animation_name)

func get_item(item) -> void:
	item_sprite.visible = true
	item_sprite.play(item['id'])

	item_holding = ItemsType.create_item(item['id'])
	item_holding['forge_level'] = item['forge_level']
	item_holding['anvil_level'] = item['anvil_level']
	item_holding['whetstone_level'] = item['whetstone_level']

func give_item():
	item_sprite.visible = false

	var gave_item = item_holding
	item_holding = ItemsType.create_item("")

	return gave_item

func drop_item() -> void:
	if item_holding['id'] == "":
		return

	Audiomanager.play_sfx("drop")
	item_sprite.visible = false

	var dropped_item = dropped_item_scene.instantiate()
	dropped_item.item = item_holding
	
	var dropped_items_node = get_tree().root.get_node("World/DroppedItems")
	dropped_items_node.add_child(dropped_item)
	dropped_item.global_position = global_position

	item_holding = ItemsType.create_item("")

func get_closest_interactable_item() -> Node2D:
	var closest_item = null
	var closest_distance = 1000000

	for item in items_in_range:
		var distance = global_position.distance_to(item.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_item = item

	return closest_item
