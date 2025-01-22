class_name AreabasedCamera extends Camera2D

func _ready():
	GAME_MANAGER.SetCamera(self)

func SetBoundsFromArea(area :Area2D): #Set limits of camera to be the room's area.
	var collShape : CollisionShape2D = area.get_child(0)
	var size = collShape.shape.size 
	var viewSize = get_viewport_rect().size
	
	if size.y < viewSize.y : size.y = viewSize.y
	if size.x < viewSize.x : size.x = viewSize.x
	
	limit_top = collShape.global_position.y - size.y /2
	limit_left = collShape.global_position.x - size.x /2
	limit_bottom = limit_top + size.y 
	limit_right = limit_left+ size.x  
	print(limit_top)

func CameraTransition(dir : Vector2):
	limit_bottom = 10000
	limit_top = -10000
	limit_left = -10000
	limit_right = 10000
	
	var nextPos :Vector2 = position + dir *  get_viewport_rect().size
	var tween = get_tree().create_tween()
	
	tween.tween_property($Sprite, "position", nextPos, 0.1)
