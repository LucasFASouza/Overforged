extends Node2D

@onready var tooltip: Label = $Tooltip
var message_base: String = "Press SPACE to interact"

@onready var player: CharacterBody2D = $"/root/World/Player"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	tooltip.visible = false
	tooltip.text = message_base

func _process(_delta: float) -> void:
	if player.current_interactable_item == self:
		sprite.play("selected")
	else:
		sprite.play("idle")

func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if _body == player:
		player.items_in_range.append(self)

func _on_interaction_area_body_exited(_body: Node2D) -> void:
	if _body == player:
		tooltip.visible = false

		if self in player.items_in_range:
			player.items_in_range.erase(self)

func interact() -> void:
	pass
