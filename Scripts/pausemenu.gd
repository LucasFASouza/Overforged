extends Control

const menu_scene = preload("res://Scenes/menu.tscn")

@onready var options: MarginContainer = %PauseOptionsContainer


func _ready() -> void:
	pass
	# options.hide()


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()


# func _on_options_button_pressed() -> void:
# 	if options.visible:
# 		options.hide()
# 	else:
# 		options.show()

# func _on_quit_button_pressed() -> void:
# 	if menu_scene:
# 		var new_scene = menu_scene.instantiate()
# 		if new_scene:
# 			get_tree().root.add_child(new_scene)
# 			get_tree().current_scene.queue_free()
# 			get_tree().current_scene = new_scene
# 		else:
# 			print("Failed to instantiate the menu scene.")
# 	else:
# 		print("Failed to load the menu scene.")
