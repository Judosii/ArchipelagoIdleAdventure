class_name Level extends Node2D

var chara : character

@export var levelName : String
@export var editorOnlyPanel : PanelContainer

@export var nodes : Array[MovementNodes]
@export var startNode : MovementNodes

func UponBeingInstantiatedForEditing():
	editorOnlyPanel.visible = true

func UponBeingInstantiatedForPlaying(player : character):
	editorOnlyPanel.visible = false
	chara = player
	chara.visible = true
	chara.global_position = startNode.global_position
