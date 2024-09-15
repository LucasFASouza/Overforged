extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ballon: AnimatedSprite2D = $Ballon
@onready var anvil_minigame = $AnvilMinigame

var state: String = 'empty'
var current_item = ItemsType.create_item("")

var clear_timer = Timer.new()

func _ready() -> void:
	message_base = "Press SPACE to interact"
	tooltip.visible = false
	state = 'empty'
	ballon.visible = false
	anvil_minigame.visible = false

	clear_timer.wait_time = 3
	clear_timer.one_shot = true
	clear_timer.connect("timeout", Callable(self, "clean"))
	add_child(clear_timer)

	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	

func interact() -> void:
	if state == 'empty':
		if player.item_holding['id'] != "iron_ingot":
			tooltip.text = 'You need an Iron Ingot to use the anvil'
			tooltip.visible = true
			return

		player.state = 'minigame'
		current_item = player.give_item()
		
		anvil_minigame.visible = true
		anvil_minigame.start_minigame()

		state = 'running'

func finish_minigame(score):
	current_item['id'] = "dull_sword"
	current_item['name'] = ItemsType.items_names.get("dull_sword", "")

	if score == 1:
		score = 1.5
	elif score == 0.5 or score == 0:
		score = 1
	current_item['anvil_level'] = score

	ballon.visible = true
	ballon.play(str(score) + "-stars")

	player.get_item(current_item)
	player.state = 'free'

	current_item = ItemsType.create_item("")
	state = 'empty'

	anvil_minigame.visible = false
	clear_timer.start()

func clean():
	ballon.play("out-stars")
