extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_interactable: bool = false

@onready var tooltip: Label = $Tooltip

@onready var player: CharacterBody2D = $"/root/World/Player"

@export var item: String = ''
@export var is_trash: bool = false;


func _ready() -> void:
	tooltip.visible = false
	tooltip.text = "Press SPACE to get the item" if not is_trash else "Press SPACE to throw the item"
	animated_sprite.play("chest" if not is_trash else "trash")

func _process(delta: float) -> void:
	if is_interactable and Input.is_action_just_pressed("ui_select"):
		if is_trash:
			player.give_item()
		elif player.check_item() == '':
			player.get_item(item)
		else:
			tooltip.text = "You have your hands full right now"


func _on_interaction_area_body_entered(_body: Node2D) -> void:
	print('is_trash', is_trash) 	
	is_interactable = true
	tooltip.visible = true


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	is_interactable = false
	tooltip.visible = false
