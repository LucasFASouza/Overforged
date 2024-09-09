extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var percentage: Label = $Percentage

var state: String = 'empty'
var duration: float = 15
var elapsed_time: float = 0.0

@export var station: String = 'forge'

const stations = {
	'forge': {
		'empty': 'metal_bruto',
		'emtpy_text': 'You need metal to start the forge',
		'ready': 'metal_forjado',
		'duration': 1
	},
	'anvil': {
		'empty': 'metal_forjado',
		'emtpy_text': 'You need forged metal to start the anvil',
		'ready': 'espada_bruta',
		'duration': 1
	},
	'whetstone': {
		'empty': 'espada_bruta',
		'emtpy_text': 'You need a sword to start the whetstone',
		'ready': 'espada_finalizada',
		'duration': 1
	}
}

func _ready() -> void:
	message_base = "Press SPACE to interact"
	tooltip.visible = false
	percentage.visible = false
	percentage.text = "0%"
	state = 'empty'

	if station not in stations:
		print("Station not found")
		return

	duration = stations[station]['duration']
	animated_sprite.animation = station
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

	if state == 'running':
		elapsed_time += delta
		percentage.text = str(int(elapsed_time / duration * 100)) + "%"

		if elapsed_time >= duration:
			state = 'ready'
			percentage.text = "READY"

func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if _body == player and state != 'running':
		player.current_interactable_item = self

		if state == 'empty':
			tooltip.text = message_base
		elif state == 'running':
			tooltip.text = "Running..."
		elif state == 'ready':
			tooltip.text = message_base

func interact() -> void:
	if state == 'empty':
		if player.item_holding != stations[station]['empty']:
			tooltip.text = stations[station]['emtpy_text']
			return

		player.give_item()
		state = 'running'
		percentage.visible = true
		elapsed_time = 0.0

	elif state == 'ready':
		if player.item_holding != '':
			tooltip.text = "You have your hands full right now"
			return

		player.get_item(stations[station]['ready'])
		state = 'empty'
		percentage.visible = false
		percentage.text = "00%"
