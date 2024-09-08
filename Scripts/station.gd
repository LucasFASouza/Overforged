extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_interactable: bool = false

const base_text = "Press SPACE to "
@onready var tooltip: Label = $Tooltip
@onready var percentage: Label = $Percentage

var state: String = 'empty'

var duration: float = 15
var elapsed_time: float = 0.0

@onready var player: CharacterBody2D = $"/root/World/Player"

@export var station: String = 'forge'

const stations = {
	'forge': {
		'empty': 'metal_bruto',
		'emtpy_text': 'You need metal to start the forge',
		'ready': 'metal_forjado',
		'duration': 5
	},
	'anvil': {
		'empty': 'metal_forjado',
		'emtpy_text': 'You need forged metal to start the anvil',
		'ready': 'espada_bruta',
		'duration': 5
	}
}



func _ready() -> void:
	tooltip.visible = false
	percentage.visible = false
	percentage.text = "0%"
	state = 'empty'

	if station not in stations:
		print("Station not found")
		return

	duration = stations[station]['duration']
	animated_sprite.animation = station
	

func _process(delta: float) -> void:
	if is_interactable and Input.is_action_just_pressed("ui_select"):
		if state == 'empty':
			if player.check_item() != stations[station]['empty']:
				tooltip.text = stations[station]['emtpy_text']
				tooltip.visible = true
				return

			player.give_item()
			state = 'running'
			percentage.visible = true
			elapsed_time = 0.0

		elif state == 'ready':
			if player.check_item() != '':
				tooltip.text = "You have your hands full right now"
				tooltip.visible = true
				return

			player.get_item(stations[station]['ready'])
			state = 'empty'
			percentage.visible = false
			percentage.text = "00%"

	if state == 'running':
		elapsed_time += delta
		percentage.text = str(int(elapsed_time / duration * 100)) + "%"

		if elapsed_time >= duration:
			state = 'ready'
			percentage.text = "READY"


func _on_interaction_area_body_entered(_body: Node2D) -> void:
	is_interactable = true

	if state == 'empty':
		tooltip.visible = true
		tooltip.text = base_text + "start the " + station

	elif state == 'ready':
		tooltip.visible = true
		tooltip.text = base_text + "collect the material"


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	is_interactable = false
	tooltip.visible = false
