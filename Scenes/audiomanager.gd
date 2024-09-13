extends Node

var sfx_dict = {}
@onready var main_music: AudioStreamPlayer2D = $Music/MainMusic
@onready var battle_music: AudioStreamPlayer2D = $Music/BattleMusi

func _ready() -> void:
	main_music.play()
	var sfx_node = $SFX
	for child in sfx_node.get_children():
		if child is AudioStreamPlayer2D: 
			sfx_dict[child.name.to_lower()] = child  

func play_sfx(sfx_name: String) -> void:
	if sfx_dict.has(sfx_name):
		sfx_dict[sfx_name].play()
	else:
		print("SFX: %s not found!" % sfx_name)
 
func switch_music(to_battle: bool):
	if to_battle:
		if main_music.playing:
			main_music.stop()
		battle_music.play()
	else:
		if battle_music.playing:
			battle_music.stop()
		main_music.play()
