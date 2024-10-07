class_name Inventory
extends Node

@export var initial_items: Array[Resource] = []

# Array to store items (could've used a dictionary too but I think that an array is enough for a roguelike)
var items: Array = []

# Function to add an item to the inventory
func add_item(new_item: Item):
	for item in items:
		if item.name == new_item.name:
			item.quantity += new_item.quantity
			return
	items.append(new_item)

# Function to remove an item by name and quantity
func remove_item(item_name: String, quantity: int = 1):
	for item in items:
		if item.name == item_name:
			item.quantity -= quantity
			if item.quantity <= 0:
				items.erase(item)
			return

# Function to retrieve an item by name
func get_item(item_name: String) -> Item:
	for item in items:
		if item.name == item_name:
			return item
	return null
