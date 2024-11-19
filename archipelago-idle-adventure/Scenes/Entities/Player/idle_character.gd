extends CharacterBody2D

const SPEED = 100
const JUMP_VELOCITY = -400.0

var aStar2D : AStar2D 
@export var travellingToNode : Node2D #node the character is going towards
var nodesThatCanBeExplored : Array[Node2D] # Backlog of all nodes to explore
var nodesThatHaveBeenExplored : Array[Node2D] # Nodes that have been explored
var nodesUnexplored : Array[Node2D] # Remainder of what to explore
# do set it at start to avoid a crash :D
# by design travelling to node can only be a node that has been in nodesThatCanBeExplored
# once a node has been reached at least once, add it to nodesThatHaveBeenExplored, AND...
# ... add its connections to nodesThatCanBeExplored if they haven't been there already.
# nodesUnexplored will be used when a character reaches a dead end, to determine where to go next.

func _ready() -> void:
	aStar2D = AStar2D.new()
	nodesThatCanBeExplored.append(travellingToNode)

func _physics_process(delta):
	var line : Line2D = get_node("Line2D")
	line.clear_points() 
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	if position.distance_to(travellingToNode.position) < 1 :
		# arrived at node
		velocity = Vector2(0,0)
		if travellingToNode not in nodesThatHaveBeenExplored:
			# Node has NOT been explored before
			#print("travellingToNode not in nodesThatHaveBeenExplored")
			RefreshLists(travellingToNode)
		ChooseNextNodeToTravelTo()
	
	else:
		# Travelling to next node
		var toBeVel : Vector2
		toBeVel = (travellingToNode.position - position).normalized() * SPEED
		velocity = toBeVel
		line.add_point(Vector2(0,0))
		line.add_point(Vector2(toBeVel * 100))
		move_and_slide()

func RefreshLists(arrivedToNode : Node2D):
	nodesThatHaveBeenExplored.append(arrivedToNode)
	#print(str("arrived at ",arrivedToNode.name, "\n next node to travel to is : ", , "\n-----"))
	var possibleNewNodes : Array[Node2D] = arrivedToNode.connectedNodes
	for i in possibleNewNodes.size():
		if nodesThatCanBeExplored.has(possibleNewNodes[i]) == false:
			nodesThatCanBeExplored.append(possibleNewNodes[i])
			print("added ", possibleNewNodes[i], " to the list \n")
	nodesUnexplored.clear()
	
	for i in nodesThatCanBeExplored.size():
		#for o in nodesThatHaveBeenExplored:
		if nodesThatHaveBeenExplored.has(nodesThatCanBeExplored[i]) == false:
			nodesUnexplored.append(nodesThatCanBeExplored[i])

func IsCurrentNodeDeadEnd() -> bool:
	print("node's connections amount to : ",travellingToNode.connectedNodes.size())
	if travellingToNode.connectedNodes.size() == 1:
		return true
	else:
		return false

func ChooseNextNodeToTravelTo():
	var shortestDistance : float
	var closestNode : Node2D
	for i in nodesUnexplored.size():
		if i == 0:
			shortestDistance = position.distance_to(nodesUnexplored[i].position)
			closestNode = nodesUnexplored[i]
		elif position.distance_to(nodesUnexplored[i].position) < shortestDistance:
			shortestDistance = position.distance_to(nodesUnexplored[i].position)
			print("new shortest distance : ", shortestDistance)
			travellingToNode = nodesUnexplored[i]
