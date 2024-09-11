extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var state: String = 'empty'
var current_item = ItemsType.create_item("")

func _ready() -> void:
	message_base = "Press SPACE to interact"
	tooltip.visible = false
	state = 'empty'

	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

	if state == 'running':
		print("Play minigame")

func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if _body == player:
		player.current_interactable_item = self

		if state == 'empty':
			tooltip.text = message_base
		elif state == 'ready':
			tooltip.text = message_base

func interact() -> void:
	if state == 'empty':
		if player.item_holding['id'] != "iron_ingot":
			tooltip.text = 'You need Iron Ingot to start the anvil'
			return

		player.state = 'minigame'
		current_item = player.give_item()

		Audiomanager.play_sfx("anvil")
		state = 'running'

	elif state == 'ready':
		if player.item_holding['id'] != '':
			tooltip.text = "You have your hands full right now"
			return

		current_item['id'] = "dull_sword"
		current_item['name'] = ItemsType.items_names.get("dull_sword", "")
		current_item['anvil_level'] = 5

		player.get_item(current_item)
		player.state = 'free'

		current_item = ItemsType.create_item("")
		state = 'empty'


# TODO: Implement minigame