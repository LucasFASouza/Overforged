extends Node2D

var is_interactable: bool = false

@onready var tooltip: Label = $Tooltip
var message_base: String = "Press SPACE to pick up item"

@export var item: String = "espada_finalizada"
@onready var item_sprite: AnimatedSprite2D = $ItemSprite

@onready var player: CharacterBody2D = $"/root/World/Player"


func _ready() -> void:
	tooltip.visible = false
	tooltip.text = message_base
	item_sprite.play(item)	


func _process(_delta: float) -> void:
	if is_interactable and Input.is_action_just_pressed("ui_select"):
		if player.check_item() != '':
			tooltip.text = "You have your hands full right now"
		else:
			player.get_item(item)
			queue_free()


func _on_interaction_area_body_entered(_body: Node2D) -> void:
	is_interactable = true
	tooltip.visible = true


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	is_interactable = false
	tooltip.visible = false
	tooltip.text = message_base
