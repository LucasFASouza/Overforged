extends "res://Scripts/interactable_item.gd"

@onready var soldiers: Node2D = $"/root/World/SoldiersGroup"

func _ready() -> void:
	message_base = "Press SPACE to sell the sword"
	tooltip.text = message_base
	super._ready()

func interact() -> void:
	if player.item_holding['id'] != 'espada_finalizada':
		tooltip.text = "You need a finished sword to sell"
	else:
		var item = player.give_item()
		soldiers.sell_weapon(item)
		player.current_interactable_item = null
		tooltip.visible = false
		tooltip.text = message_base
