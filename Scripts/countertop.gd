extends Node2D

var is_interactable: bool = false

@onready var tooltip: Label = $Tooltip
var message_base: String = "Press SPACE to sell the sword"

@onready var player: CharacterBody2D = $"/root/World/Player"

@onready var game_manager: Control = $"/root/World/GameManager"


func _ready() -> void:
	tooltip.visible = false
	tooltip.text = message_base


func _process(_delta: float) -> void:
	if is_interactable and Input.is_action_just_pressed("ui_select"):
		if player.check_item() != 'espada_finalizada':
			tooltip.text = "You need a finished sword to sell"
		else:
			player.give_item()
			game_manager.sell_weapon("espada_finalizada")


func _on_interaction_area_body_entered(_body: Node2D) -> void:
	is_interactable = true
	tooltip.visible = true


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	is_interactable = false
	tooltip.visible = false
	tooltip.text = message_base
