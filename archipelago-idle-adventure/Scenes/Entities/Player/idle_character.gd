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


func _physics_process(delta):
	var line : Line2D = get_node("Line2D")
	line.clear_points() 
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	if position.distance_to(travellingToNode.position) < 1 :
		# arrived at node
		velocity = Vector2(0,0)
		if GAMEMANAGER.HasCurrentNodehasBeenExplored(travellingToNode):
			# Node has NOT been explored before
			#print("travellingToNode not in nodesThatHaveBeenExplored")
			GAMEMANAGER.RefreshLists(travellingToNode)
		ChooseNextNodeToTravelTo()
	
	else:
		# Travelling to next node
		var toBeVel : Vector2
		toBeVel = (travellingToNode.position - position).normalized() * SPEED
		velocity = toBeVel
		line.add_point(Vector2(0,0))
		line.add_point(Vector2(toBeVel * 100))
		move_and_slide()

func IsCurrentNodeDeadEnd() -> bool:
	print("node's connections amount to : ",travellingToNode.connectedNodes.size())
	if travellingToNode.connectedNodes.size() == 1:
		return true
	else:
		return false

func ChooseNextNodeToTravelTo():
	if travellingToNode.connectedNodes.size() == 1 || travellingToNode.connectedNodes.size() == 2:
		pass
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
