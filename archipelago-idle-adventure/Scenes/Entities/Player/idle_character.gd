class_name character extends CharacterBody2D

@export var active = false # set to true when able to play and launched.
#set to false when connection is lost, not connected to AP, or whatever else.
var paused = false #For room transitions and whatnot

@export var SPEED = 100

@export var _stateMachine : StateMachine #Used to get the current state (ie current behaviour)
@export var startNode : MovementNodes #the node the player will first start at.
@export var travellingToNode : MovementNodes #node the character currently is going towards

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

func EnteredANewRoom():
	# Pause for a second, make camera transition to next room
	pass

func TransitionToNewRoom():
	# Fade to black, pause player movement. Switch to next room based on node. Fade in, resume player.
	pass
