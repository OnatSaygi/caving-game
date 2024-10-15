class_name Place extends Node

@export var length: int = 5

@export var wind: float = 0.2
@export var sprink: float = 0.23
@export var biodiversity: float = 0.5
@export var loose_rocks: float = 0.43
@export var rocks_cleaned: bool = false
@export var mud: bool = false

@export var riggable: bool = false 
@export var rig_object: RigObject

@export var campground: bool = true
@export var next: Array[Place]
