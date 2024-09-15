extends Control

var game_scene = preload("res://Scenes/world.tscn")

@onready var side_panel: Panel = $MarginContainer/MenuContainer/SideMenu/Panel

@onready var options: Control = $MarginContainer/MenuContainer/SideMenu/Panel/OptionsContainer/Options
@onready var controls: Control = $MarginContainer/MenuContainer/SideMenu/Panel/ControlsContainer/Controls
@onready var how_to_play: Control = $MarginContainer/MenuContainer/SideMenu/Panel/HowToPlayContainer/HowToPlay


func _ready() -> void:
	side_panel.hide()
	options.hide()
	controls.hide()
	how_to_play.hide()

func _on_start_button_pressed() -> void:
	var new_scene = game_scene.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene.queue_free() 
	get_tree().current_scene = new_scene 


func change_side_panel(new_panel: Control) -> void:
	if new_panel.visible:
		side_panel.hide()
		new_panel.hide()
	else:
		side_panel.show()
		options.hide()
		controls.hide()
		how_to_play.hide()
		new_panel.show()


func _on_options_button_pressed() -> void:
	change_side_panel(options)

func _on_controls_button_pressed() -> void:
	change_side_panel(controls)


func _on_how_to_play_button_pressed() -> void:
	change_side_panel(how_to_play)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
