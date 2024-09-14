extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ballon: AnimatedSprite2D = $Ballon
@onready var whetstone_minigame = $WhetstoneMinigame

var state: String = 'empty'
var current_item = ItemsType.create_item("")

var clear_timer = Timer.new()

func _ready() -> void:
	message_base = "Press SPACE to interact"
	tooltip.visible = false
	state = 'empty'
	ballon.visible = false

	clear_timer.wait_time = 3
	clear_timer.one_shot = true
	clear_timer.connect("timeout", Callable(self, "clean"))
	add_child(clear_timer)

	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if _body == player:
		player.current_interactable_item = self

		if state == 'empty':
			tooltip.text = message_base

func interact() -> void:
	if state == 'empty':
		if player.item_holding['id'] != "dull_sword":
			tooltip.text = 'You need Dull Sword to start the anvil'
			return

		player.state = 'minigame'
		current_item = player.give_item()

		tooltip.text = "Hold SPACE to sharpen the sword at the right spot"
		whetstone_minigame.visible = true
		whetstone_minigame.start_minigame()

		state = 'running'

		player.player_sprite.play("back_idle")

func finish_minigame(score):
	current_item['id'] = "finished_sword"
	current_item['name'] = ItemsType.items_names.get("finished_sword", "")

	if score > 2.5:
		score = 3
	elif score > 2:
		score = 2.5
	elif score > 1.5:
		score = 2
	elif score > 1:
		score = 1.5
	else:
		score = 1
	
	ballon.visible = true
	ballon.play(str(score) + "-stars")

	current_item['whetstone_level'] = score

	player.get_item(current_item)
	player.state = 'free'

	current_item = ItemsType.create_item("")
	state = 'empty'

	tooltip.text = "You scored " + str(score) + "/3 stars!"

	whetstone_minigame.visible = false
	clear_timer.start()

func clean():
	ballon.visible = false
