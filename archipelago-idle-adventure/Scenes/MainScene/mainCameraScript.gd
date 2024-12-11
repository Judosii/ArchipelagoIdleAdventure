extends Camera2D

func OnRoomEntered(area:Area2D):
	var collShape : CollisionShape2D = area.get_child(0)
	var size = collShape.shape.size * 2
	
	var viewSize = get_viewport_rect().size
	if size.y < viewSize.y : size.y = viewSize.y
	if size.x < viewSize.x : size.x = viewSize.x
	
	limit_top = collShape.global_position.y - size/2
	limit_left = collShape.global_position.x - size.x/2
	limit_bottom = limit_top + size.y
	limit_right = limit_left+ size.x
	# MultiScreen rooms
	# one screen rooms
