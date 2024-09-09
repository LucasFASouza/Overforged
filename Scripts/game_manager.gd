extends Control

var weapons_sold: Array = []
var string_list: String = ""

@onready var weapons_list: Label = $WeaponsList

func sell_weapon(weapon) -> void:
	weapons_sold.append(weapon)

	string_list = "Weapons sold: \n\n"

	for weapon_item in weapons_sold:
		string_list += "- " + weapon_item['name'] + "\n"
		string_list += "- - Forge Level: " + str(weapon_item['forge_level']) + "\n"
		string_list += "- - Anvil Level: " + str(weapon_item['anvil_level']) + "\n"
		string_list += "- - Whetstone Level: " + str(weapon_item['whetstone_level']) + "\n\n"

	weapons_list.text = string_list
