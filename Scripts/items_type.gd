extends Node

class_name ItemsType

class Item:
	var id
	var name
	var forge_level
	var anvil_level
	var whetstone_level

	func _init(given_id = "", given_name = "", given_forge_level = null, given_anvil_level = null, given_whetstone_level = null):
		self.id = given_id
		self.name = given_name
		self.forge_level = given_forge_level
		self.anvil_level = given_anvil_level
		self.whetstone_level = given_whetstone_level

static var items_names: Dictionary = {
	"metal_bruto": "Metal Ore",
	"metal_forjado": "Forged Metal",
	"espada_bruta": "Raw Sword",
	"espada_finalizada": "Finished Sword",
}

static var ids_options: Array = [
	"metal_bruto",
	"metal_forjado",
	"espada_bruta",
	"espada_finalizada",
]

static func get_item_name(given_id: String) -> String:
	return items_names.get(given_id, "Empty")

static func create_item(given_id: String) -> Item:
	return Item.new(given_id, get_item_name(given_id))
