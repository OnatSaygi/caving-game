extends Resource
class_name InventoryData

@export var weight_capacity: int = 0
@export var volume_capacity: int = 0

var weight: int = 0
var volume: int = 0

@export var slot_datas: Array[SlotData]:
	set(new_value):
		slot_datas = new_value
		
		volume = 0
		weight = 0
		for slot in slot_datas:
			if slot:
				volume += slot.volume
				weight += slot.weight
