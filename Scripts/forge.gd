extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ballon: AnimatedSprite2D = $Ballon
@onready var forge_bar: Node2D = $ForgeBar

var state: String = 'empty'

@export var duration: float = 10
@export var max_time: float = 20

var elapsed_time: float = 0.0
var current_item = ItemsType.create_item("")

func _ready() -> void:
	message_base = "Press SPACE to start the forge"
	tooltip.visible = false
	ballon.visible = false
	state = 'empty'

	forge_bar.visible = false
	forge_bar.max_health = duration
	forge_bar.set_health(0)

	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	elapsed_time += delta

	if state == 'running':
		forge_bar.set_health(elapsed_time)

		if elapsed_time >= duration:
			state = 'ready'
			forge_bar.visible = false

			ballon.visible = true
			ballon.play("ready")

	elif state == 'ready':
		if elapsed_time >= max_time + 3:
			ballon.visible = false
			elapsed_time = 0.0
			
		elif elapsed_time >= max_time:
			state = 'empty'
			current_item = ItemsType.create_item("")

			Audiomanager.play_sfx("melting",true)
			Audiomanager.play_sfx("forgeburning",false)

			ballon.play("sad")
		elif elapsed_time >= max_time - 4:
			ballon.play("attention-blinking")
		elif elapsed_time >= max_time - 7:
			ballon.play("attention")
		else:
			if ballon.animation != "ready":
				ballon.play("ready")

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
		Audiomanager.play_sfx("forgestart",true)
		Audiomanager.play_sfx("forgeburning",true)
		state = 'running'
		forge_bar.visible = true
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

		ballon.visible = false
		
		Audiomanager.play_sfx("forgeburning",false)
