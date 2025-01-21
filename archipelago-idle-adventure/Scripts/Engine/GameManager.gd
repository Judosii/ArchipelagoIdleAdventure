extends Node
signal startScrollTransition
signal endScrollTransition

var mainCam: AreabasedCamera
var player: NavMeshCharacter

func SetCamera(newCam: AreabasedCamera):
	mainCam = newCam

func GetCamera() -> AreabasedCamera:
	return mainCam

func CameraScrollTransition(area: Area2D):
	startScrollTransition.emit()
	SetCameraBounds(area)

func SetCameraBounds(area: Area2D):
	mainCam.SetBoundsFromArea(area)
