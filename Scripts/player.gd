extends CharacterBody2D

@export var speed: int = 70

var current_direction: String = "front"
var is_moving: bool = false
var animation_name: String = "front_idle"

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var item_sprite: AnimatedSprite2D = $ItemSprite

var ItemsType = preload("items_type.gd").new()
var item_holding = ItemsType.create_item("")
const dropped_item_scene = preload("res://Scenes/dropped_item.tscn")

var current_interactable_item = null

func _physics_process(_delta: float) -> void:
	player_movement()

	if Input.is_action_just_pressed("ui_select"):
		if current_interactable_item != null:
			current_interactable_item.interact()
		elif item_holding['id'] != "":
			drop_item()

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
	item_sprite.visible = false

	var dropped_item = dropped_item_scene.instantiate()
	dropped_item.item = item_holding
	
	var dropped_items_node = get_tree().root.get_node("World/DroppedItems")
	dropped_items_node.add_child(dropped_item)
	dropped_item.global_position = global_position

	item_holding = ItemsType.create_item("")
