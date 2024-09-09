extends Control

var weapons_sold: Array = []

@onready var weapons_list: Label = $WeaponsList

func _ready() -> void:
	weapons_list.text = "Weapons sold: \n\n"

func sell_weapon(weapon) -> void:
	weapons_sold.append(weapon)

	weapons_list.text += "- " + weapon['name'] + "\n"
	weapons_list.text += "- - Forge Level: " + str(weapon['forge_level']) + "\n"
	weapons_list.text += "- - Anvil Level: " + str(weapon['anvil_level']) + "\n"
	weapons_list.text += "- - Whetstone Level: " + str(weapon['whetstone_level']) + "\n\n"
