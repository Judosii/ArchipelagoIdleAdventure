class_name RoomBasedCamera extends Camera2D

func _ready() -> void:
	GAMEMANAGER.SetMainCam(self)

func OnRoomEntered(area:RoomCameraArea):
	var collShape : CollisionShape2D = area.get_child(0)
	var size = collShape.shape.size
	var viewSize = get_viewport_rect().size
	
	if size.y < viewSize.y : size.y = viewSize.y
	if size.x < viewSize.x : size.x = viewSize.x
	
	
	limit_top = collShape.global_position.y - size.y /2
	limit_left = collShape.global_position.x - size.x /2
	limit_bottom = limit_top + size.y 
	limit_right = limit_left+ size.x  
	
