extends "res://Scripts/interactable_item.gd"

@export var item = {
	"id": "iron_ore",
	"name": "Iron Ore",
	"forge_level": null,
	"anvil_level": null,
	"whetstone_level": null,
}

@onready var item_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 4
var direction: int = 1
var timer: Timer = Timer.new()

func _ready() -> void:
	timer.wait_time = 0.5
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

	message_base = "Press SPACE to pick up item"
	item_sprite.play(item['id'])
	super._ready()

func _process(_delta: float) -> void:
	if player.current_interactable_item == self:
		sprite.play(item['id'] + "_selected")
	else:
		sprite.play(item['id'])

func _physics_process(delta: float) -> void:
	item_sprite.position.y += speed * direction * delta

func interact() -> void:
	if player.item_holding['id'] != '':
		tooltip.visible = true
		tooltip.text = "You have your hands full right now"
	else:
		player.get_item(item)
		Audiomanager.play_sfx("pickup")
		queue_free()

func _on_timer_timeout() -> void:
	direction *= -1
