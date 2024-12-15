class_name RoomCameraArea extends Area2D
@onready var coll : CollisionShape2D = get_node("CollisionShape2D")

func _ready():
	var viewSize = get_viewport_rect().size
	if coll.shape.size.y < viewSize.y : coll.shape.size.y = viewSize.y
	if coll.shape.size.x < viewSize.x : coll.shape.size.x = viewSize.x
	connect("area_entered", _on_area_entered)
	get_node("CollisionShape2D").disabled = false

func _on_area_entered(area):
	if area.get_parent() is character:
		#area.get_parent().active = false
		print("character entered zone !")
		GAMEMANAGER.mainCam.OnRoomEntered(self)
