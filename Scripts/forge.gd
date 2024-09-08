extends CharacterBody2D


var is_interactable: bool = false

const base_text = "Press SPACE to "
@onready var tooltip: Label = $Tooltip
@onready var percentage: Label = $Percentage

var state: String = 'empty'

@export var duration: float = 15
var elapsed_time: float = 0.0

@onready var player: CharacterBody2D = $"/root/World/Player"



func _ready() -> void:
	tooltip.visible = false
	percentage.visible = false
	percentage.text = "0%"



func _process(delta: float) -> void:
	if is_interactable and Input.is_action_just_pressed("ui_select"):
		if state == 'empty':
			if player.check_item() != 'metal_bruto':
				tooltip.text = "You need metal to start the forge"
				tooltip.visible = true
				return

			player.give_item()
			state = 'running'
			percentage.visible = true
			elapsed_time = 0.0
		# elif state == 'running':
		# 	print("Handle the forge!!")
		elif state == 'ready':
			if player.check_item() != '':
				tooltip.text = "You have your hands full right now"
				tooltip.visible = true
				return

			player.get_item('metal_forjado')
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
		tooltip.text = base_text + "start the forge"
	# elif state == 'running':
	# 	tooltip.text = base_text + "handle the forge"
	elif state == 'ready':
		tooltip.visible = true
		tooltip.text = base_text + "collect the material"


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	is_interactable = false
	tooltip.visible = false
