extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var item_id: String = ''

var item = ItemsType.create_item(item_id)

@export var is_trash: bool = false
var mode

func _ready() -> void:
	message_base = "Press SPACE to get the item" if not is_trash else "Press SPACE to throw the item"
	mode = "chest" if not is_trash else "trash"
	animated_sprite.play(mode)

	item['id'] = item_id
	item['name'] = ItemsType.get_item_name(item_id)
	
	super._ready()

func interact() -> void:
	if is_trash:
		player.give_item()
	elif player.item_holding['id'] == '':
		player.get_item(item)
		Audiomanager.play_sfx(mode)
	else:
		tooltip.visible = true
		tooltip.text = "You have your hands full right now"

func _process(_delta: float) -> void:
	if player.current_interactable_item == self:
		sprite.play(mode + "_selected")
	else:
		sprite.play(mode)
