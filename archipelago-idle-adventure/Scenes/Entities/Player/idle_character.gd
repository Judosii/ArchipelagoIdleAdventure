class_name character extends CharacterBody2D


@export var SPEED = 100

@export var _stateMachine : StateMachine
@export var startNode : MovementNodes
@export var travellingToNode : MovementNodes #node the character is going towards

func _ready():
	travellingToNode = startNode
	GAMEMANAGER.PlayerReady(startNode, self)

func _physics_process(delta: float) -> void:
	#_stateMachine.StateFunction(delta)
	TravellingToNode()

func ArrivedAtNode():
	print("-----------------------------------------------------")
	if !GAMEMANAGER.HasCurrentNodeBeenExplored(travellingToNode):
		# Node has been explored before
		GAMEMANAGER.RefreshLists(travellingToNode)
	_stateMachine.StateLogic()

func TravellingToNode():
	var toBeVel : Vector2
	toBeVel = (travellingToNode.global_position - global_position).normalized() * SPEED
	velocity = toBeVel
	move_and_slide()
