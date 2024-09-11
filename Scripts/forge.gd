extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var percentage: Label = $Percentage

var state: String = 'empty'

@export var duration: float = 10
@export var warning_time: float = 15
@export var max_time: float = 20
@export var clean_time: float = 25

var elapsed_time: float = 0.0
var current_item = ItemsType.create_item("")

func _ready() -> void:
	message_base = "Press SPACE to start the forge"
	tooltip.visible = false
	percentage.visible = false
	percentage.text = "0%"
	state = 'empty'

	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	elapsed_time += delta

	if state == 'running':
		percentage.text = str(int(elapsed_time / duration * 100)) + "%"

		if elapsed_time >= duration:
			state = 'ready'
			percentage.text = "READY"
	elif state == 'ready':
		if elapsed_time >= clean_time:
			state = 'empty'
			percentage.visible = false
			percentage.text = "00%"
		if elapsed_time >= max_time:
			percentage.text = "BURNED :("
			state = 'empty'
			elapsed_time = 0.0
			current_item = ItemsType.create_item("")
		elif elapsed_time >= warning_time:
			percentage.text = "CAREFUL!!!"


func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if _body == player and state != 'running':
		player.current_interactable_item = self

		if state == 'empty':
			tooltip.text = "Press SPACE to start the forge"
		elif state == 'running':
			tooltip.text = "Running..."
		elif state == 'ready':
			tooltip.text = "Press SPACE get your item"

func interact() -> void:
	if state == 'empty':
		if player.item_holding['id'] != "iron_ore":
			tooltip.text = 'You need Iron Ore to start the forge'
			return

		current_item = player.give_item()
		Audiomanager.play_sfx("forge")
		state = 'running'
		percentage.visible = true
		elapsed_time = 0.0

	elif state == 'ready':
		if player.item_holding['id'] != '':
			tooltip.text = "You have your hands full right now"
			return

		current_item['id'] = "iron_ingot"
		current_item['name'] = ItemsType.items_names.get("iron_ingot", "")
		current_item['forge_level'] = 5

		player.get_item(current_item)
		current_item = ItemsType.create_item("")
		state = 'empty'
		percentage.visible = false
		percentage.text = "00%"
