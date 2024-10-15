class_name Inventory extends Resource

# yuzeyin bir envanteri olmali
# magaradaki her cantanin envanteri
# oda
# karakterlerin de envanteri olmali
# kafa lambasi tasiyor
# yemek, aktif alet, enerji

@export var name: String = ""
@export var items: Array[Item] = []
@export var filter: Array[ItemData] = []

@export var has_max_weight: bool = false
@export var max_weight: int = 0

@export var has_max_volume: bool = false
@export var max_volume: int = 0

var weight: int = 0 :
	set(value):
		push_error("Cannot set inventory weight")
	get:
		var total: int = 0
		for item in items:
			total += item.weight
		return total

var volume: int = 0 :
	set(value):
		push_error("Cannot set inventory volume")
	get:
		var total: int = 0
		for item in items:
			total += item.volume
		return total

func _init(
		_items: Array[Item] = [],
		_filter: Array[ItemData] = []
		) -> void:
	items = _items
	filter = _filter
	print('egegegege')
	return

func _to_string():
	var s: String = "%s inventory " % name
	s += "%5.2f Kg %5.2f l\n" % [weight/1000., volume/1000.]
	
	for item in items:
		s += "%s\n" % item
	s += "containing %d items.\n" % items.size()
	return s

#func merge_by_index(index: int, item: Item) -> void:
#	return

#func swap_by_index(index: int, item: Item) -> void:
#	return

func add(hand: Item) -> Item:
	if filter:
		if not hand.data in filter:
			push_error("%s cannot be put in %s inventory" % [hand, name])
			return hand
	if has_max_weight:
		if weight + hand.weight > max_weight:
			# TODO partial fill
			push_error('%s exceeds %s inventory weight' % [hand, name])
			return hand
	if has_max_volume:
		if volume + hand.volume > max_volume:
			push_error('%s exceeds %s inventory weight' % [hand, name])
			return hand
	for _item in items:
		if hand.data == _item.data:
			_item = _item.merge_with(hand)
			return null
	items.append(hand)
	return null

## does this work
func pop_by_index(item: Item, i: int) -> Item:
	return items.pop_at(i)

func pop_one_by_index(item: Item, i: int) -> Item:
	item = items[i].split_by_count(item, 1)
	return item

## FIXME
func pop_half_by_index(item: Item, i: int) -> Item:
	item = items[i].split_by_count(item, ceil(items[i].count/2.0))
	print('pop %s from inv' % item)
	return item

func find(item: Item):
	return items.find(item)
