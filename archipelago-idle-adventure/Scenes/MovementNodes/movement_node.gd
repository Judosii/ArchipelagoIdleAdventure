class_name MovementNodes extends Node2D

@export var connectedNodes : Array[MovementNodes]

@export var nodeName : String

func _ready():
	get_node("Label").text = nodeName
