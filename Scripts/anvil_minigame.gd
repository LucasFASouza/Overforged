extends Node2D

@export var speed = 100
var direction = -1
var is_stopped = false

@onready var hammer: CharacterBody2D = $Hammer
var is_sweetspot = false


func _process(delta):
	if not is_stopped:
		hammer.position += Vector2(speed * delta * direction * -1, 0)
	else:
		print("Victory? ", is_sweetspot)
	
	if Input.is_action_just_pressed("ui_select"):
		is_stopped = true

func _on_sweetspot_body_entered(body: Node2D) -> void:
	is_sweetspot = true
	print("Sweetspot entered")

func _on_sweetspot_body_exited(body: Node2D) -> void:
	is_sweetspot = false
	print("Sweetspot exited")

func _on_min_x_body_entered(body: Node2D) -> void:
	print("Bateu")
	direction = -1

func _on_max_x_body_entered(body: Node2D) -> void:
	print("Bateu")
	direction = 1

# TODO:
# - Make graphics
# - Each try should have a different sweetspot
# - Make faster and a smalles sweetspot
# - After 3 times it ends

# Open when anvil is active
# Give pontuation based on either number of tries ou how close to the sweetspot it was 
# may need to rework logic to calculation of position rather than a collision