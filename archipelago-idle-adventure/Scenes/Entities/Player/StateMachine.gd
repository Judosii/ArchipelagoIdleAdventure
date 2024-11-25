class_name StateMachine extends Node2D

@export var startingState : _State
var currentState : _State

func _ready() -> void:
	currentState = startingState
	currentState.ActivateState()

func SwitchState(nextState : String):
	var state : _State = get_node(nextState)
	currentState.DeactivateState()
	state.ActivateState()

func StateFunction(delta:float):
	currentState.StateFunctionality()
