@tool
extends HBoxContainer


@export var amount: int = 123:
	set(value):
		amount = value
		if is_inside_tree():
			%MoneyLabel.text = str(amount)


func _ready() -> void:
	amount = amount
