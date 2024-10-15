extends Resource
class_name SlotData

const MAX_STACK_SIZE: int = 99

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1

var weight: int = 0:
	get:
		return item_data.weight * quantity
var volume: int = 0:
	get:
		return item_data.volume * quantity
