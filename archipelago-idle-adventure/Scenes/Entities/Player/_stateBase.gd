class_name _State extends Node2D

var playerCharacter : character
var stateMachine : StateMachine

func _ready() -> void:
	stateMachine = get_parent()
	playerCharacter = stateMachine.get_parent()

func StateFunctionality():
	pass

func ActivateState():
	stateMachine.currentState = self

func DeactivateState():
	pass
