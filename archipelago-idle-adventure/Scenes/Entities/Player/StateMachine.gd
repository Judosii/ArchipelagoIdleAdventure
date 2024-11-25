class_name StateMachine extends Node2D

@export var startingState : _State
var currentState : _State

func _ready() -> void:
	currentState = startingState
	currentState.ActivateState()

func SwitchState(nextState : String):
	print("\nSwitching state to : ", nextState," !")
	var state : _State = get_node(nextState)
	currentState.DeactivateState()
	state.ActivateState()

func StateLogic():
	currentState.ArrivedAtNodeLogic()
