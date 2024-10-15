extends HBoxContainer

@onready var icon = $Icon/Icon
@onready var count = $Count/Count
@onready var label = $Label/Label
@onready var total_volume = $Volume/Volume/TotalVolume
@onready var total_weight = $Weight/Weight/TotalWeight

@export var slot_data: SlotData:
	set(value):
		print('wwww')
		slot_data = value
		update()

func update():
	if slot_data:
		var item_data = slot_data.item_data

		icon.texture = item_data.texture
		label.text = item_data.name
		count.text = "%s" % slot_data.quantity
		total_volume.text = "%s" % slot_data.volume
		total_volume.show()
		total_weight.text = "%s" % slot_data.weight
		total_weight.show()
		
		$Icon.show()
		$Label.show()
		$Volume.show()
		$Weight.show()
		$empty.hide()
	else:
		$Icon.hide()
		$Label.hide()
		$Volume.hide()
		$Weight.hide()
		$empty.show()

func _ready():
	update()
