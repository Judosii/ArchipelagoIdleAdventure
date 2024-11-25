class_name MovementNodes extends Node2D

@export var connectedNodes : Array[MovementNodes]

@export var nodeName : String

func _ready():
	get_node("Label").text = nodeName
	var line : Line2D = get_node("Line2D")
	for i in connectedNodes.size():
		line.add_point(connectedNodes[i].position - position)
		line.add_point(Vector2(0,0))


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
