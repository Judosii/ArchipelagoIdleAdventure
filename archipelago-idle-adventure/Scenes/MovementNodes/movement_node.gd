class_name MovementNodes extends Node2D

@export var connectedNodes : Array[MovementNodes]

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is character:
		var chara : character = area.get_parent()
		chara.ArrivedAtNode()
