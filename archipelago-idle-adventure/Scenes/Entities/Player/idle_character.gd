class_name character extends CharacterBody2D

@export var active = false

@export var SPEED = 100

@export var _stateMachine : StateMachine
@export var startNode : MovementNodes
@export var travellingToNode : MovementNodes #node the character is going towards

func _ready():
	if active:
		#Archipelago.open_console()
		travellingToNode = startNode
		GAMEMANAGER.PlayerReady(startNode, self)

func _physics_process(_delta: float) -> void:
	if active :
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

func _on_button_button_down():
	SPEED = 400

func GetPlayerActive() -> bool:
	return active

func SetPlayerActive(b : bool):
	active = b
