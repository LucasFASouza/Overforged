extends "res://Scripts/interactable_item.gd"

@export var item = {
	"id": "iron_ore",
	"name": "Iron Ore",
	"forge_level": null,
	"anvil_level": null,
	"whetstone_level": null,
}

@onready var item_sprite: AnimatedSprite2D = $ItemSprite

func _ready() -> void:
	message_base = "Press SPACE to pick up item"
	tooltip.text = message_base
	item_sprite.play(item['id'])
	super._ready()

func interact() -> void:
	if player.item_holding['id'] != '':
		tooltip.text = "You have your hands full right now"
	else:
		player.get_item(item)
		queue_free()
