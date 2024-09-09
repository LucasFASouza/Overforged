extends Node2D

@onready var tooltip: Label = $Tooltip
var message_base: String = "Press SPACE to interact"

@onready var player: CharacterBody2D = $"/root/World/Player"

func _ready() -> void:
	tooltip.visible = false
	tooltip.text = message_base

func _process(_delta: float) -> void:
	if player.current_interactable_item == self:
		tooltip.visible = true
	else:
		tooltip.visible = false

func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if _body == player:
		player.current_interactable_item = self

func _on_interaction_area_body_exited(_body: Node2D) -> void:
	if _body == player:
		tooltip.text = message_base
		if player.current_interactable_item == self:
			player.current_interactable_item = null

func interact() -> void:
	pass
