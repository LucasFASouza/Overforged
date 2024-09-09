extends Node

class_name ItemsType

class Item:
	var id
	var name
	var forge_level
	var anvil_level
	var whetstone_level

	func _init(id = "", name = "", forge_level = null, anvil_level = null, whetstone_level = null):
		self.id = id
		self.name = name
		self.forge_level = forge_level
		self.anvil_level = anvil_level
		self.whetstone_level = whetstone_level

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

static func get_item_name(id: String) -> String:
	return items_names.get(id, "Empty")

static func create_item(id: String) -> Item:
	var name = get_item_name(id)
	return Item.new(id, name)
