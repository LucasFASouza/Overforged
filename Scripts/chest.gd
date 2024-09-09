extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var item_id: String = ''

var ItemsType = preload("items_type.gd").new()
var item = ItemsType.create_item(item_id)

@export var is_trash: bool = false

func _ready() -> void:
	message_base = "Press SPACE to get the item" if not is_trash else "Press SPACE to throw the item"
	tooltip.text = message_base
	animated_sprite.play("chest" if not is_trash else "trash")

	item['id'] = item_id
	item['name'] = ItemsType.get_item_name(item_id)
	
	super._ready()

func interact() -> void:
	if is_trash:
		player.give_item()
	elif player.item_holding['id'] == '':
		player.get_item(item)
	else:
		tooltip.text = "You have your hands full right now"
