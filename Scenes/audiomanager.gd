extends Node

var sfx_dict = {}
@onready var main_music: AudioStreamPlayer2D = $Music/MainMusic
@onready var battle_music: AudioStreamPlayer2D = $Music/BattleMusic

func _ready() -> void:
	main_music.play()
	var sfx_node = $SFX
	for child in sfx_node.get_children():
		if child is AudioStreamPlayer2D: 
			sfx_dict[child.name.to_lower()] = child  


func play_sfx(sfx_name: String, play: bool = true) -> void:
	if sfx_dict.has(sfx_name):
		if play:
			if not sfx_dict[sfx_name].is_playing():
				sfx_dict[sfx_name].play()
		else:
			if sfx_dict[sfx_name].is_playing():
				sfx_dict[sfx_name].stop()
			
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

func _process(delta):
	var whetstone: AudioStreamPlayer2D = $SFX/Whetstone
	if Input.is_action_pressed("interact"):
		whetstone.pitch_scale = 0.5
	else:
		whetstone.pitch_scale = 1
	
