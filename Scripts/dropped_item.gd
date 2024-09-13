extends "res://Scripts/interactable_item.gd"

@export var item = {
	"id": "iron_ore",
	"name": "Iron Ore",
	"forge_level": null,
	"anvil_level": null,
	"whetstone_level": null,
}

@onready var item_sprite: AnimatedSprite2D = $ItemSprite

@export var speed: float = 4
var direction: int = 1
var timer: Timer = Timer.new()

func _ready() -> void:
	timer.wait_time = 0.5
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

	message_base = "Press SPACE to pick up item"
	tooltip.text = message_base
	item_sprite.play(item['id'])
	super._ready()

func _physics_process(delta: float) -> void:
	item_sprite.position.y += speed * direction * delta

func interact() -> void:
	if player.item_holding['id'] != '':
		tooltip.text = "You have your hands full right now"
	else:
		player.get_item(item)
		queue_free()

func _on_timer_timeout() -> void:
	direction *= -1
