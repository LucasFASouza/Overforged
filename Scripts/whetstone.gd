extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ballon: AnimatedSprite2D = $Ballon
@onready var whetstone_minigame = $WhetstoneMinigame

var state: String = 'empty'
var current_item = ItemsType.create_item("")

var clear_timer = Timer.new()

func _ready() -> void:
	state = 'empty'
	ballon.visible = false

	clear_timer.wait_time = 3
	clear_timer.one_shot = true
	clear_timer.connect("timeout", Callable(self, "clean"))
	add_child(clear_timer)

	super._ready()

func _process(delta: float) -> void:
	super._process(delta)


func interact() -> void:
	if state == 'empty':
		if player.item_holding['id'] != "dull_sword":
			tooltip.text = 'You need a Dull Sword to use the whetstone'
			tooltip.visible = true
			return

		player.state = 'minigame'
		current_item = player.give_item()

		whetstone_minigame.visible = true
		whetstone_minigame.start_minigame()

		state = 'running'

		player.position = position + Vector2(0, 10)
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

	whetstone_minigame.visible = false
	clear_timer.start()

func clean():
	ballon.play("out-stars")
