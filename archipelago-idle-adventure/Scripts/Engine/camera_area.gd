extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is NavMeshCharacter:
		var chara : NavMeshCharacter = body
		chara.EnteredCameraArea()
