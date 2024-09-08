extends Control

var weapons_sold: Array = []
var string_list: String = ""

@onready var weapons_list: Label = $WeaponsList

func sell_weapon(weapon: String) -> void:
	weapons_sold.append(weapon)

	string_list = "Weapons sold: \n"

	for weapon_item in weapons_sold:
		string_list += "- " + weapon_item + "\n"

	weapons_list.text = string_list
