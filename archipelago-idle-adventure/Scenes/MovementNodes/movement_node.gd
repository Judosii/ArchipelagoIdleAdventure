extends Node2D

@export var connectedNodes : Array[Node2D]

@export var nodeName : String

func _ready():
	get_node("Label").text = nodeName
