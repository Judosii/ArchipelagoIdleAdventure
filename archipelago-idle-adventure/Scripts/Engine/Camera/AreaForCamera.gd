extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is NavMeshCharacter:
		print("Character entered zone!")
		var chara : NavMeshCharacter = area.get_parent()
		GAME_MANAGER.CameraScrollTransition(self)
