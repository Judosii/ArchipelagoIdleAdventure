extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = -400.0

@export var startNode : MovementNodes

@export var travellingToNode : MovementNodes #node the character is going towards
var currentObjectiveNode : MovementNodes
# do set them at start to avoid a crash :D

# by design travellingToNode can only be a node that has been in nodesThatCanBeExplored
# once a node has been reached at least once, add it to nodesThatHaveBeenExplored, AND...
# ... add its connections to nodesThatCanBeExplored if they haven't been there already.
# nodesUnexplored will be used when a character reaches a dead end, to determine where to go next.

func _ready():
	GAMEMANAGER.PlayerReady(startNode)

func _physics_process(delta):
	var label : Label = get_node("Label")
	label.text = travellingToNode.name
	var line : Line2D = get_node("Line2D")
	line.clear_points() 
	if position.distance_to(travellingToNode.position) < 1 :
		ArrivedAtNode()
	else:
		TravellingToNode(line)

func ArrivedAtNode():
	velocity = Vector2(0,0)
	print(GAMEMANAGER.HasCurrentNodeBeenExplored(travellingToNode))
	if !GAMEMANAGER.HasCurrentNodeBeenExplored(travellingToNode):
		# Node has been explored before
		GAMEMANAGER.RefreshLists(travellingToNode)
	if GAMEMANAGER.IsHintAvailable():
		#Is there a hint available to access ?
		pass
	elif !IsCurrentNodeDeadEnd() :
		print("-> current node is not a dead end ! \n")
		# Path is not a dead end, get next closest path
	elif HasObtainedItem():
		print("-> has, in fact, obtained item !")
		# Recalculate open paths
		# Also check for Go Mode
		if GAMEMANAGER.IsGoMode():
			set_physics_process(false)
		elif GAMEMANAGER.CheckPreviouslyUnavailablePaths():
			set_physics_process(false)
		else:
			set_physics_process(false)
			#Needs to wait for an item.
	elif GAMEMANAGER.nodesUnexplored.size() > 0:
		# is at least 1 path explorable ?
		set_physics_process(false)
	
	#ChooseNextNodeToTravelTo()

func TravellingToNode(line : Line2D):
	var toBeVel : Vector2
	toBeVel = (travellingToNode.position - position).normalized() * SPEED
	velocity = toBeVel
	line.add_point(Vector2(0,0))
	line.add_point(Vector2(travellingToNode.global_position))
	move_and_slide()

func IsCurrentNodeDeadEnd() -> bool:
	print("\nIs current node dead end ?")
	print("- node's connections amount to : ",travellingToNode.connectedNodes.size())
	if travellingToNode.connectedNodes.size() == 1:
		if travellingToNode.connectedNodes[0] in GAMEMANAGER.nodesThatHaveBeenExplored:
			print("-> connection has been explored. Would loop. Finding new path. ")
			return true
		else:
			travellingToNode = travellingToNode.connectedNodes[0]
			print("-> connection has not been explored. Continuing.")
			return false
	else:
		print("-> this is not a dead end.")
		return true

func ChooseNextNodeToTravelTo():
	var shortestDistance : float
	# following needs to be redone
	#for i in nodesUnexplored.size():
		#if i == 0:
			#shortestDistance = position.distance_to(nodesUnexplored[i].position)
			#travellingToNode = nodesUnexplored[i]
		#elif position.distance_to(nodesUnexplored[i].position) < shortestDistance:
			#shortestDistance = position.distance_to(nodesUnexplored[i].position)
			#print("new shortest distance : ", shortestDistance)
			#travellingToNode = nodesUnexplored[i]

func HasObtainedItem() -> bool:
	# if an item has been obtained, 
	# recalculate open paths after
	return false
