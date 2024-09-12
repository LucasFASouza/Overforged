extends Node

var sfx_dict = {}


func _ready() -> void:
	var sfx_node = $SFX
	for child in sfx_node.get_children():
		if child is AudioStreamPlayer2D: 
			sfx_dict[child.name.to_lower()] = child  

func play_sfx(sfx_name: String) -> void:
	if sfx_dict.has(sfx_name):
		sfx_dict[sfx_name].play()
	else:
		print("SFX: %s not found!" % sfx_name)
