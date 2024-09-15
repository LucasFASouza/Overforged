extends Control

var game_scene = preload("res://Scenes/world.tscn")
@onready var game_over_text_label: Label = $MarginContainer/VBoxContainer/MenuContainer/MarginContainer/PanelContainer/Main/GameOverTextLabel
@onready var result_text_label: Label = $MarginContainer/VBoxContainer/MenuContainer/MarginContainer/PanelContainer/Main/ResultTextLabel



func _on_try_again_button_pressed() -> void:
	var new_scene = game_scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free() 
	get_tree().current_scene = new_scene 


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func change_endscreen_text(text: String, result: String):
	game_over_text_label.text = text
	result_text_label.text = result
