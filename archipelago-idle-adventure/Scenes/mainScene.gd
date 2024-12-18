extends Node

@export_category("Main menu connections")
@export var mainMenu : Control
#call this to access the main menu / options and others

@export var main2D : Node2D
#instance levels HERE ONLY

@export var levelsFolderExplorer : Control
#upon clicking this, shows a list of all levels that can be played (made and are on disk)

@export var RecentLevelsMade : Control
#upon clicking "editor button"
# Shows recent levels made that are still available on disk
# Also shows a "create level button"

@export var camera : Camera2D
#need to call the camera ? here you go

@export_category("Container References")
@export var playRecentLevels : Container
@export var playExploreFiles : Container
@export var editLevelsExplorer : Container

## LEVEL LOADING VARS
var levelInstance : Node2D
# the level you're playing on

var chosenLevel : Resource
#Level chosen by choose_level_button_down, used to load the level

@export_category("")
@export var recentLevelsResource : recentLevels

func _ready() -> void:
	GAMEMANAGER.mainCam = camera

func unloadLevel():
	if (is_instance_valid(levelInstance)):
		levelInstance.queue_free()
	levelInstance = null

func loadLevel(levelName : String):
	unloadLevel()
	var levelPath = "res://Levels/%s" % levelName
	print(levelName)
	var levelResource := load(levelPath)
	if levelResource :
		levelInstance = levelResource.instantiate()
		main2D.add_child(levelInstance)
		#print(levelInstance)
	if recentLevelsResource.levelName.size() != 0:
		if recentLevelsResource.levelName.has(levelInstance.name):
			# level has already been loaded once before.
			var index = recentLevelsResource.levelName.bsearch(levelInstance.name)
			recentLevelsResource.levelName.remove_at(index)
			recentLevelsResource.levelName.push_front(levelInstance)
	else:
		# loading baby's first level !
		recentLevelsResource.levelName.append(levelName)
		recentLevelsResource.levelpath.append("res://Levels/%s"% levelName)

func LevelChosen(levelPath : String):
	chosenLevel = load(levelPath)

func BackToMainMenu():
	mainMenu.visible = true
	levelsFolderExplorer.visible = false
	RecentLevelsMade.visible = false

# Followed this tutorial for file exploring :
# https://youtu.be/mC4Wb_NHKA8?si=qVmsGqYBg_OVUTKQ

@export_category("File Explorer Stuff")
var lvlFolderExplPath :String = ""
var file : bool = true

func ShowLevelsInFiles(cont:Container):
	file = false
	for i in cont.get_children():
		i.queue_free()
	var dir = DirAccess.open("res://Levels")
	dir.list_dir_begin()
	var fileName = dir.get_next()
	while fileName != "":
		if fileName.get_extension() == "tscn":
			var nBut = Button.new()
			nBut.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			nBut.text = fileName
			#print(nBut.text)
			cont.add_child(nBut)
			nBut.pressed.connect(loadLevel.bind(fileName))
		fileName = dir.get_next()

func ShowRecentLevelsPlayed(cont:Container):
	if ResourceLoader.exists("res://Engine/MainSceneStuff/recentLevels.tres"):
		recentLevelsResource = ResourceLoader.load("res://Engine/MainSceneStuff/recentLevels.tres")
	
	file = false
	for i in cont.get_children():
		i.queue_free()
	for i in recentLevelsResource.levelName.size():
		var nBut = Button.new()
		nBut.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		nBut.text = str(recentLevelsResource.levelName[i])
		cont.add_child(nBut)
		nBut.pressed.connect(loadLevel.bind(nBut.text))

func FileChosen(fileName : String):
	chosenLevel = load("res://Levels/%s"% fileName)
	if file :
		lvlFolderExplPath = lvlFolderExplPath.get_base_dir()
	lvlFolderExplPath = lvlFolderExplPath + "/" + fileName
	#as we are always in res://Levels, it's not used.
	file = true
	#print(chosenLevel)
	loadLevel(chosenLevel.resource_name)

# All connections from buttons and such

func _on_level_folder_back_to_main_menu_button_down() -> void:
	BackToMainMenu()

func _on_play_level_button_down() -> void:
	#Can only be used on main menu
	HideMainMenu()
	ShowLevelsInFiles(playExploreFiles)
	ShowRecentLevelsPlayed(playRecentLevels)
	#Show recent levels played

func _on_level_editor_button_down():
	#Can only be used on main menu
	#Open the level editor with levelInstance
	HideMainMenu()
	ShowLevelsInFiles(editLevelsExplorer)

func HideMainMenu():
	mainMenu.visible = false
	levelsFolderExplorer.visible = true
