extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var item: String = ''
@export var is_trash: bool = false

func _ready() -> void:
	message_base = "Press SPACE to get the item" if not is_trash else "Press SPACE to throw the item"
	tooltip.text = message_base
	animated_sprite.play("chest" if not is_trash else "trash")
	super._ready()

func interact() -> void:
	if is_trash:
		player.give_item()
	elif player.item_holding == '':
		player.get_item(item)
	else:
		tooltip.text = "You have your hands full right now"
