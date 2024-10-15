extends PanelContainer

const SlotUI = preload("res://ui/SlotUI.tscn")
var a = preload("res://test/test_inventory.tres")
var inventory: InventoryData:
	set(value):
		inventory = value
		
		# remove existing ui slots
		for child in slots.get_children():
			child.queue_free()
		
		# create new ui slots
		for slot_data in inventory.slot_datas:
			var slot = SlotUI.instantiate()
			slots.add_child(slot)
			
			if slot_data:
				slot.slot_data = slot_data

@onready var slots: VBoxContainer = $VBoxContainer/Items
@onready var volume = $VBoxContainer/SummaryBar/Volume/Volume/Volume
@onready var weight = $VBoxContainer/SummaryBar/Weight/Weight/Weight

func _ready():
	inventory = a
	pass
	#populate_item_grid(inventory)

#func populate_item_grid(inventory: InventoryData) -> void:

func _process(delta):
	if inventory:
		volume.text = "%-7.2f" % [inventory.volume/1000.]
		#volume.text = "%d%.2d" % [inventory.volume/1000, inventory.volume%100]
		weight.text = "%s" % inventory.weight
