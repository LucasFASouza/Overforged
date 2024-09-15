extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ballon: AnimatedSprite2D = $Ballon
@onready var forge_bar: Node2D = $ForgeBar

var state: String = 'empty'


var elapsed_time: float = 0.0
var current_item = ItemsType.create_item("")

func _ready() -> void:
	ballon.visible = false
	state = 'empty'

	forge_bar.visible = false
	forge_bar.max_health = 10
	forge_bar.set_health(0)

	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	elapsed_time += delta

	if state == 'running':
		forge_bar.set_health(elapsed_time)

		if elapsed_time >= 10:
			state = 'ready'
			forge_bar.visible = false

			ballon.visible = true
			ballon.play("ready")

	elif state == 'ready':
		if elapsed_time >= 25:
			state = 'empty'
			current_item = ItemsType.create_item("")

			Audiomanager.play_sfx("melting",true)
			Audiomanager.play_sfx("forgeburning",false)

			ballon.play("sad")
		elif elapsed_time >= 20:
			ballon.play("attention-blinking")
		elif elapsed_time >= 15:
			ballon.play("attention")
		else:
			if ballon.animation != "ready":
				ballon.play("ready")
	else:
		if elapsed_time >= 28:
			if ballon.animation != "out":
				ballon.play("out")
			elapsed_time = 0.0

func interact() -> void:
	if state == 'empty':
		if player.item_holding['id'] != "iron_ore":
			tooltip.text = 'You need an Iron Ore to start the forge'
			tooltip.visible = true
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
			tooltip.visible = true
			return

		current_item['id'] = "iron_ingot"
		current_item['name'] = ItemsType.items_names.get("iron_ingot", "")
		current_item['forge_level'] = 5

		player.get_item(current_item)
		current_item = ItemsType.create_item("")
		state = 'empty'

		if ballon.animation != "out":
			ballon.play("out")
		
		Audiomanager.play_sfx("forgeburning",false)
