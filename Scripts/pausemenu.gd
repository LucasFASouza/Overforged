extends Control

const menu_scene = preload("res://Scenes/menu.tscn")

@onready var options: MarginContainer = %PauseOptionsContainer
@onready var how_to_play: MarginContainer = %HTPContainer


func _ready() -> void:
	options.hide()
	how_to_play.hide()


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	hide()


func toggle_active_section(section: MarginContainer) -> void:
	if section.visible:
		section.hide()
	else:
		options.hide()
		how_to_play.hide()

		section.show()

func _on_options_button_pressed() -> void:
	toggle_active_section(options)


func _on_how_to_play_button_pressed() -> void:
	toggle_active_section(how_to_play)


func _on_quit_button_pressed() -> void:
	if menu_scene:
		var new_scene = menu_scene.instantiate()

		get_tree().root.add_child(new_scene)
		get_tree().paused = false
		get_tree().current_scene.queue_free()
		get_tree().current_scene = new_scene

	else:
		print("Failed to load the menu scene.")
