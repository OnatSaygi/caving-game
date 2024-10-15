extends Node2D

func _ready():
	var batterydata = preload("res://itemsystem/itemdata/battery.tres")
	var drilldata = preload("res://itemsystem/itemdata/drill.tres")
	
	var inventory = Inventory.new([Item.new(batterydata, 6)])
	inventory.name = "Kelleci sandik"
	
	var hand1: Item = Item.new(batterydata, 10)
	var hand2: Item
	
	#print(inventory)
	print("hand1 %s" % hand1)
	print("hand2 %s" % hand2)
	print("")
	
	hand2 = hand1.split_by_count(hand2, 3)
	#hand = item.split_by_count(hand, count)
	print("hand1 %s" % hand1)
	print("hand2 %s" % hand2)
	print("")
	
	hand1 = hand1.join(hand2)
	print("hand1 %s" % hand1)
	print("hand2 %s" % hand2)
	print("")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
