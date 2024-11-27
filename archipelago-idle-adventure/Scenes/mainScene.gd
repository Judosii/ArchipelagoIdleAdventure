extends Node

@export var hud : Control
#Call this to access hud
@export var mainMenu : Control
#call this to access the main menu / options and others
@export var main2D : Node2D
#instance levels HERE ONLY
@export var camera : Camera2D
#need to call the camera ? here you go

var levelInstance : Node2D
# the level you're playing on

func unloadLevel():
	if (is_instance_valid(levelInstance)):
		levelInstance.queue_free()
	levelInstance = null

func loadLevel(levelName : String):
	unloadLevel()
	var levelPath = "res://Levels/%s.tscn" % levelName
	var levelResource := load(levelPath)
	if levelResource :
		levelInstance = levelResource.instance()

func _on_play_level_button_down() -> void:
	OS.shell_show_in_file_manager("res://Levels")
