extends "res://Scripts/interactable_item.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var original_material = animated_sprite.material
@onready var shader_material = load("res://Scripts/shader.gdshader")

@export var item_id: String = ''

var item = ItemsType.create_item(item_id)

@export var is_trash: bool = false

func _ready() -> void:
	message_base = "Press SPACE to get the item" if not is_trash else "Press SPACE to throw the item"
	tooltip.text = message_base
	animated_sprite.play("chest" if not is_trash else "trash")

	animated_sprite.material = ShaderMaterial.new()
	animated_sprite.material = shader_material if is_trash else original_material

	item['id'] = item_id
	item['name'] = ItemsType.get_item_name(item_id)
	
	super._ready()

func interact() -> void:
	if is_trash:
		player.give_item()
	elif player.item_holding['id'] == '':
		player.get_item(item)
		Audiomanager.play_sfx("chest")
	else:
		tooltip.text = "You have your hands full right now"

func _process(_delta: float) -> void:
	var mode = "chest" if not is_trash else "trash"

	if player.current_interactable_item == self:
		tooltip.visible = true
		sprite.play(mode + "_selected")
	else:
		tooltip.visible = false
		sprite.play(mode)
