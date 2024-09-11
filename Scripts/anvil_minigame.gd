extends Node2D

@export var speed = 100
var direction = -1
var is_stopped = false

@onready var hammer: CharacterBody2D = $Hammer
var hammer_min
var hammer_max

@onready var sweetspot: Node2D = $Sweetspot
var sweetspot_min
var sweetspot_max


func _process(delta):
	if not is_stopped:
		hammer.position += Vector2(speed * delta * direction * -1, 0)
	else:
		# TODO: This is not working, it's getting the relative position, instead of abslute
		sweetspot_min = sweetspot.get_node("MinX").position.x
		sweetspot_max = sweetspot.get_node("MaxX").position.x
		
		hammer_min = hammer.get_node("MinX").position.x
		hammer_max = hammer.get_node("MaxX").position.x

		# Check if hammer is inside sweetspot
		print("The sweet spot was: ", sweetspot_min, sweetspot_max)
		print("The hammer was: ", hammer_min, hammer_max)
		
		if hammer_min >= sweetspot_min and hammer_max <= sweetspot_max:
			print("Max Success - 3 Stars")
		elif hammer_min >= sweetspot_min or hammer_max <= sweetspot_max:
			print("Not Bad - 2 Stars")
		else:
			print("Fail - 1 Star")
	
	if Input.is_action_just_pressed("ui_select"):
		is_stopped = true

func _on_min_x_body_entered(_body: Node2D) -> void:
	direction = -1

func _on_max_x_body_entered(_body: Node2D) -> void:
	direction = 1

# TODO:
# - Make graphics
# - Each try should have a different sweetspot
# - Make faster and a smalles sweetspot
# - After 3 times it ends

# Open when anvil is active
# Give pontuation based on either number of tries ou how close to the sweetspot it was 
# may need to rework logic to calculation of position rather than a collision
