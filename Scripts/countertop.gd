extends "res://Scripts/interactable_item.gd"

@onready var game_manager: Control = $"/root/World/GameManager"

func _ready() -> void:
	message_base = "Press SPACE to sell the sword"
	tooltip.text = message_base
	super._ready()

func interact() -> void:
	if player.item_holding != 'espada_finalizada':
		tooltip.text = "You need a finished sword to sell"
	else:
		player.give_item()
		game_manager.sell_weapon("espada_finalizada")
		player.current_interactable_item = null
		tooltip.visible = false
		tooltip.text = message_base
