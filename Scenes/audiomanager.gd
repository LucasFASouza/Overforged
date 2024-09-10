extends Node

@onready var anvil_sfx: AudioStreamPlayer2D = $Anvil_SFX
@onready var whetstone_sfx: AudioStreamPlayer2D = $Whetstone_SFX
@onready var forge_sfx: AudioStreamPlayer2D = $Forge_SFX
@onready var main_music: AudioStreamPlayer2D = $MainMusic

func _ready() -> void:
	pass

func play_sfx(station):
	if station == "anvil":
		anvil_sfx.play()
	if station == "whetstone":
		whetstone_sfx.play()
	if station == "forge":
		forge_sfx.play()
		
