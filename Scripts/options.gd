extends Control



var master_bus_id = AudioServer.get_bus_index("Master")
var sfx_bus_id = AudioServer.get_bus_index("SFX")
var music_bus_id = AudioServer.get_bus_index("Music")
var user_prefs = UserPreferences

@onready var master_slider: HSlider = $OptionsContainer/MarginContainer/VBoxContainer/MasterSlider
@onready var music_slider: HSlider = $OptionsContainer/MarginContainer/VBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $OptionsContainer/MarginContainer/VBoxContainer/SFXSlider


func _ready() -> void:
	user_prefs = UserPreferences.load_or_create()
	if master_slider:
		master_slider.value = user_prefs.master_audio_level
	if music_slider:
		music_slider.value = user_prefs.music_audio_level
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_audio_level

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(master_bus_id, value < .05)
	if user_prefs:
		user_prefs.master_audio_level = value
		print("master audio value: ", value)
		user_prefs.save()


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_id, value < .05)
	if user_prefs:
		user_prefs.music_audio_level = value
		user_prefs.save()


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_id, value < .05)
	if user_prefs:
		user_prefs.sfx_audio_level = value
		user_prefs.save()
