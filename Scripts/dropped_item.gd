extends "res://Scripts/interactable_item.gd"

@export var item: String = "metal_bruto"
@onready var item_sprite: AnimatedSprite2D = $ItemSprite

func _ready() -> void:
	message_base = "Press SPACE to pick up item"
	tooltip.text = message_base
	item_sprite.play(item)
	super._ready()

func interact() -> void:
	if player.item_holding != '':
		tooltip.text = "You have your hands full right now"
	else:
		player.get_item(item)
		queue_free()
