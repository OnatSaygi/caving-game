class_name Item extends Resource

@export var data: ItemData			## Type of the item.
@export var count: int = 1			## How many of this item
@export var condition: float = 1.0	## Item's condition
var weight: int = 0 :				## Read only
	set(value):
		push_error("Cannot set item weight")
	get:
		return data.weight * count
var volume: int = 0 :				## Read only
	set(value):
		push_error("Cannot set item volume")
	get:
		return data.volume * count

func _init(_data: ItemData, _count: int = 1, _condition: float = 1.0):
	data = _data
	count = _count
	condition = _condition

func _to_string(verbose: bool = false):
	return "[%d %s] %5.2f Kg %5.2f l" % [count, data, weight/1000., volume/1000.]

# Attempts to join another item into itself
# hand = item.join(hand)
func join(hand: Item) -> Item:
	if self == hand:
		push_error('bu olmamamli')
		return
	if data.stackable and data == hand.data:
		count += hand.count
		return null
	return hand

# Attempts to split item into hand
# hand = item.split_by_count(hand, count)
func split_by_count(hand: Item, _count: int) -> Item:
	if count <= _count:
		return hand
	if hand == null:
		count -= _count
		hand = Item.new(data, _count)
		return hand
	if data == hand.data:
		count -= _count
		hand.count += _count
		return hand
	return hand

func test(hand: Item) -> void:
	
	pass
# kafa lambasi
# matkap 
# survey tools (mezura, lazer, lidar)
# camera (flash)
# cooking set (mikro ocak) (isinmak icin de)
# food
# food (density)
# coffee
# water
# uncertain water
# sampling kit 
