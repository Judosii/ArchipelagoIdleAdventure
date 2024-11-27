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
var chosenLevel : Resource
#Level chosen by choose_level_button_down

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

func LevelChosen(levelPath : String):
	chosenLevel = load(levelPath)

func _on_play_level_button_down() -> void:
	#Can only be used on main menu
	loadLevel(chosenLevel.name)

func _on_level_editor_button_down():
	#Can only be used on main menu
	#Open the level editor with levelInstance
	setLayout()
	print("bbb")

# Followed this tutorial for file exploring :
# https://youtu.be/mC4Wb_NHKA8?si=qVmsGqYBg_OVUTKQ
@export var cont :Container
var path :String = ""
var file : bool = true

func setLayout():
	file = false
	for i in cont.get_children():
		i.queue_free()
	var dir = DirAccess.open("res://Levels")
	dir.list_dir_begin()
	var fileName = dir.get_next()
	while fileName != "":
		var nBut = Button.new()
		nBut.text = fileName
		cont.add_child(nBut)
		if dir.current_is_dir():
			#It's a folder. Filter this out.
			pass
		else:
			nBut.pressed.connect(FileChosen.bind(fileName))
		fileName = dir.get_next()

func FileChosen(fileName : String):
	if file :
		path = path.get_base_dir()
	path = path + "/" + fileName
	#NPath.text // Npath is not used! it's a lineEdit to show the path.
	#as we are always in res://Levels, it's not used.
	file = true
