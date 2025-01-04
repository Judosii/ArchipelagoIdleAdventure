extends Node

#region variables

@export_category("Main menu connections")
@export var mainMenu : Control
#call this to access the main menu / options and others

@export var main2D : Node2D
#instance levels HERE ONLY

@export var chooseLevelToPlay : Control
#upon clicking "editor button"
# Shows recent levels made that are still available on disk
# Also shows a "create level button"

@export var chooseLevelToEdit : Control
#upon clicking this, shows a list of all levels that can be played (made and are on disk)

@export var camera : Camera2D
#need to call the camera ? here you go

@export var player : character
#need to call the player ? yup.

@export_category("Container References")
@export var playRecentLevels : Container
@export var playExploreFiles : Container
@export var editLevelsExplorer : Container

## LEVEL LOADING VARS
var levelInstance : Level
# the level you're playing on

var chosenLevel : Resource
#Level chosen by choose_level_button_down, used to load the level

@export_category("")
@export var recentLevelsResource : recentLevels
#endregion

func _ready() -> void:
	GAMEMANAGER.mainCam = camera

#region MainMenuButtonConnections
func _on_level_folder_back_to_main_menu_button_down() -> void:
	# hide both chooseLevelToPlay and levelsExplorer, and show the main Menu
	BackToMainMenu()

func BackToMainMenu():
	chooseLevelToPlay.visible = false
	chooseLevelToEdit.visible = false
	mainMenu.visible = true

func _on_play_level_button_down() -> void:
	#Can only be used on main menu
	#Show recent levels played, and playable level files
	HideMainMenu()
	chooseLevelToPlay.visible = true
	ShowLevelsForPlay()
	#ShowRecentlyPlayedLevels()

func _on_level_editor_button_down():
	#Can only be used on main menu
	#Open the level editor with levelInstance
	HideMainMenu()
	chooseLevelToEdit.visible = true
	ShowLevelsForEditing()
#endregion

#region FileExplorerFromTutorial
func ShowRecentlyPlayedLevels():
	pass
	#Show last 10 played levels
	#Put this level on front

func ShowLevelsForPlay():
	AddButtonsFromFilesTo(playExploreFiles, loadForPlaying)
	#Show levels in the chooseLevelToPlay/Panel_FileExplorer
	#Update last 10 played levels, put this level on front
	#ShowLevelsInFiles(cont)

func ShowLevelsForEditing():
	#print("aaaaaaaaa")
	AddButtonsFromFilesTo(editLevelsExplorer, loadForEditing)
	#Show levels in the chooseLevelToEdit/GridContainer

func HideMainMenu():
	mainMenu.visible = false

# Followed tutorial Godot4.0 file explorer
# https://youtu.be/mC4Wb_NHKA8?si=xLarcffF__10XMSh
func AddButtonsFromFilesTo(cont : Container, connectTo : Callable):
	#Remove previous children, 
	for i in cont.get_children():
		cont.get_node(str(i)).queue_free()
	#print("has removed already existing buttons")
	
	var dir = DirAccess.open("res://Levels")
	#print("has opened levels folder")
	dir.list_dir_begin()
	var fileName = dir.get_next()
	while fileName != "":
		#print("loading file : ", fileName)
		var nBut : Button = Button.new()
		nBut.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		nBut.text = fileName
		cont.add_child(nBut)
		#print(nBut.get_parent())
		if dir.current_is_dir() :
			#Is a directory.
			pass
		else:
			#is a file.
			nBut.pressed.connect(connectTo.bind(fileName))
		fileName = dir.get_next()

func AddButtonsFromResourceTo(cont: Container):
	pass
	#for i in resource.recentLevelsName.size():
#endregion

#region ActuallyLoadingLevel
func unloadLevel():
	if (is_instance_valid(levelInstance)):
		levelInstance.queue_free()
	levelInstance = null

func loadForEditing(levelName:String):
	loadLevel(levelName)
	levelInstance.UponBeingInstantiatedForEditing()

func loadForPlaying(levelName:String):
	loadLevel(levelName)
	levelInstance.UponBeingInstantiatedForPlaying(player)

func loadLevel(levelName : String):
	unloadLevel()
	var levelPath = "res://Levels/%s" % levelName
	#print(levelPath)
	var levelResource : PackedScene = load(levelPath)
	if levelResource:
		levelInstance = levelResource.instantiate()
		main2D.add_child(levelInstance)
		chooseLevelToEdit.visible = false
		chooseLevelToPlay.visible = false
	else:
		printerr("What.")
		#print(levelInstance)

func LevelChosen(levelPath : String):
	chosenLevel = load(levelPath)
#endregion
