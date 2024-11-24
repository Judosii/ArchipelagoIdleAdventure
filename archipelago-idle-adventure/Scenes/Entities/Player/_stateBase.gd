class_name _State extends Node2D

var character : CharacterBody2D = get_parent().get_parent()
var stateMachine : StateMachine = get_parent()

func StateFunctionality():
	pass

func ActivateState():
	stateMachine.currentState = self

func DeactivateState():
	pass
