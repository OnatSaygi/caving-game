@icon("res://itemsprites/product.png")
class_name ItemData extends Resource

@export var name: String = "Unnamed"

@export_group("Properties")
enum Type {
	singular,
	singular_with_condition,
	stacking,
}
@export var type: Type
@export var icon: Texture
@export_multiline var description: String = ""
@export var volume: int = 0
@export var weight: int = 0
@export var weight_offset: int = 0 ##How much weight changes with condiotion
var stackable

func _init():
	stackable = (type == Type.stacking)

func _to_string():
	return name
