extends Node

@export var mainMenu: Control
@export var levelsFolder : Control

var middlePos : Vector2 = Vector2(0,0)
var screenSize : Vector2 = DisplayServer.window_get_size()
var leftSide:			Vector2 = Vector2(-576,0)
var rightSide:			Vector2 = Vector2(576,0)
var top:				Vector2 = Vector2(0,-324)
var bottom:				Vector2 = Vector2(0,324)
var topLeftCorner:		Vector2 = Vector2(-576, -324)
var topRightCorner:		Vector2 = Vector2(576, -324)
var bottomLeftCorner:	Vector2 = Vector2(-576, 324)
var bottomRightCorner:	Vector2 = Vector2(576, 324)

# FileExplorer is at top left corner for show
# Main Menu is at middle

func ShowFilesForPlay():
	var tw : Tween = create_tween()
	tw.set_parallel(true)
	tw.tween_property(mainMenu, "rect_position",rightSide,1)
	tw.tween_property(levelsFolder, "rect_position", Vector2(-screenSize.x, -324) ,1)
	tw.play()

func ShowFilesForEditor():
	pass

func HideFilesForMainMenu():
	pass
