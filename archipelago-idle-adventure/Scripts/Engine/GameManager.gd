extends Node
signal startScrollTransition
signal endScrollTransition

var mainCam: AreabasedCamera

func SetCamera(newCam: AreabasedCamera):
	mainCam = newCam

func GetCamera() -> AreabasedCamera:
	return mainCam

func SetCameraBounds(area: Area2D):
	mainCam.SetBoundsFromArea(area)
	endScrollTransition.emit()

func CameraScrollTransition(area: Area2D):
	startScrollTransition.emit()
