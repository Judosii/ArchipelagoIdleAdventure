class_name character extends CharacterBody2D


@export var SPEED = 100

@export var _stateMachine : StateMachine
@export var startNode : MovementNodes
@export var travellingToNode : MovementNodes #node the character is going towards

var noMoreExplorableNodes : bool

func _ready():
	travellingToNode = startNode
	GAMEMANAGER.PlayerReady(startNode, self)

func _physics_process(delta: float) -> void:
	#_stateMachine.StateFunction(delta)
	if noMoreExplorableNodes:
		pass
	else:
			TravellingToNode()

#func _physics_process(delta):
	#var label : Label = get_node("Label")
	#label.text = travellingToNode.name
	#if position.distance_to(travellingToNode.position) < 1 :
		#ArrivedAtNode()
	#else:
		#TravellingToNode()

func ArrivedAtNode():
	if !GAMEMANAGER.HasCurrentNodeBeenExplored(travellingToNode):
		# Node has been explored before
		GAMEMANAGER.RefreshLists(travellingToNode)
	_stateMachine.StateLogic()

func TravellingToNode():
	var toBeVel : Vector2
	toBeVel = (travellingToNode.global_position - global_position).normalized() * SPEED
	velocity = toBeVel
	move_and_slide()

func NodeIsBranchingPath() -> bool:
	print("\n is current node branching into paths ?")
	var numberOfConnectionsAlreadyVisited : int = 0
	for i in travellingToNode.connectedNodes.size():
		if travellingToNode.connectedNodes[i] in GAMEMANAGER.nodesThatHaveBeenExplored:
			numberOfConnectionsAlreadyVisited += 1
	if travellingToNode.connectedNodes.size() - numberOfConnectionsAlreadyVisited > 1:
		print("- yes")
		return true
	else:
		print("- no")
		return false

func IsCurrentNodeNotADeadEnd() -> bool:
	print("\nIs current node a dead end ?")
	print("- node's connections amount to : ",travellingToNode.connectedNodes.size())
	if travellingToNode.connectedNodes.size() == 1:
		if travellingToNode.connectedNodes[0] not in GAMEMANAGER.nodesThatHaveBeenExplored:
			print("-> DeadEnd node; one path available.")
			return true
		else:
			print("-> dead end")
			return false
	
	elif travellingToNode.connectedNodes.size() == 2:
		print("-> corridor node, 2 paths available")
		var connectionsExplored : int
		for i in travellingToNode.connectedNodes.size():
			if travellingToNode.connectedNodes[i] in GAMEMANAGER.nodesThatHaveBeenExplored:
				connectionsExplored += 1
		print("there are ", connectionsExplored, "explored paths from this node")
		if connectionsExplored == travellingToNode.connectedNodes.size():
			print("-> all current connections have already been explored.")
			return false
		else:
			print("One path is still unexplored from this node.")
			return true
	else:
		print("reached end of IsCurrentNodeADeadEnd. Something's wrong.")
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

func IsStuck(b : bool):
	pass
