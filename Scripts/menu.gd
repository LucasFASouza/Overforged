extends Control

var game_scene = preload("res://Scenes/world.tscn")

func _on_start_button_pressed() -> void:
	var new_scene = game_scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free() 
	get_tree().current_scene = new_scene 
