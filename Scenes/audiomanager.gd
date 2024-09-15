extends Node

var sfx_dict = {}
var music_dict = {}


func _ready() -> void:
	var sfx_node = $SFX
	for child in sfx_node.get_children():
		if child is AudioStreamPlayer2D: 
			sfx_dict[child.name.to_lower()] = child  

	var music_node = $Music
	for child in music_node.get_children():
		if child is AudioStreamPlayer2D: 
			music_dict[child.name.to_lower()] = child
	switch_music("main")


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
 

func switch_music(track_name: String):
	for music in music_dict.values():
		if music.playing:
			music.stop()
	if music_dict.has(track_name):
		music_dict[track_name].play()
	else:
		print("Music track: %s not found!" % track_name)


func _process(delta):
	var whetstone: AudioStreamPlayer2D = $SFX/Whetstone
	if Input.is_action_pressed("interact"):
		whetstone.pitch_scale = 0.5
	else:
		whetstone.pitch_scale = 1
	
