extends Control

var game_scene = preload("res://Scenes/world.tscn")

@onready var side_panel: Panel = $MarginContainer/MenuContainer/SideMenu/Panel

@onready var about: Control = $MarginContainer/MenuContainer/SideMenu/Panel/AboutContainer/About
@onready var options: Control = $MarginContainer/MenuContainer/SideMenu/Panel/OptionsContainer/Options

func _on_start_button_pressed() -> void:
	var new_scene = game_scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free() 
	get_tree().current_scene = new_scene 



func _on_options_button_pressed() -> void:
	if options.visible:
		options.hide()
		side_panel.hide()
	else:
		side_panel.show()
		about.hide()
		options.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_about_button_pressed() -> void:
	if about.visible:
		about.hide()
		side_panel.hide()
	else:
		side_panel.show()
		options.hide()
		about.show()
