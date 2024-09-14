extends Control

var game_scene = preload("res://Scenes/world.tscn")
@onready var options: MarginContainer = %OptionsContainer



func _ready() -> void:
	options.hide()


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_options_button_pressed() -> void:
	if options.visible:
		options.hide()
	else:
		options.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
