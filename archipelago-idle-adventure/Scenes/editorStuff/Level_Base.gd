class_name Level extends Node2D

var chara : character

@export var levelName : String
@export var editorOnlyPanel : PanelContainer

@export var nodes : Array[MovementNodes]
@export var startNode : MovementNodes

@export_group("EditorPositions")
@export var editorPosition1 : Node2D
@export var editorPosition2 : Node2D

@export_group("EditorStuff")
@export var editorHideButton : Button
@export var editorShowButton : Button


func UponBeingInstantiatedForEditing():
	editorOnlyPanel.visible = true
	editorHideButton.pressed.connect(_on_HideMenuButton_pressed)
	editorShowButton.pressed.connect(_on_ShowMenuButton_pressed)

func UponBeingInstantiatedForPlaying(player : character):
	editorOnlyPanel.visible = false
	if player == null: chara = player
	chara.ActivateNodeDetectionArea()
	chara.visible = true
	chara.global_position = startNode.global_position

func _on_ShowMenuButton_pressed() -> void:
	editorOnlyPanel.set_position(editorPosition1.position)
	editorHideButton.visible = true
	editorHideButton.disabled = false
	editorShowButton.visible = false
	editorShowButton.disabled = true


func _on_HideMenuButton_pressed() -> void:
	editorOnlyPanel.set_position(editorPosition2.position)
	editorHideButton.visible = false
	editorHideButton.disabled = true
	editorShowButton.visible = true
	editorShowButton.disabled = false
