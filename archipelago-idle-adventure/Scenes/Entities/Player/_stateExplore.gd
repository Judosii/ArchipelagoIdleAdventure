extends _State

var travellingToNode : MovementNodes
var nodePathToObjective : Array[MovementNodes]
var currentObjectiveNode : MovementNodes

@export var stateGoToHint : _State

func ArrivedAtNode():
	character.velocity = Vector2(0,0)
	#print(GAMEMANAGER.HasCurrentNodeBeenExplored(travellingToNode))
	if !GAMEMANAGER.HasCurrentNodeBeenExplored(travellingToNode):
		# Node has been explored before
		GAMEMANAGER.RefreshLists(travellingToNode)
	
	if GAMEMANAGER.IsHintAvailable():
		stateMachine.SwitchState(stateGoToHint.name)
		pass
		#Is there a hint available to access ?
	
	if currentObjectiveNode != null && travellingToNode == nodePathToObjective[nodePathToObjective.size() -1]:
		print("Arrived at objective ! \nStart exploring randomly again.")
		currentObjectiveNode = null
		nodePathToObjective.clear()
	elif currentObjectiveNode != null :
		print("character has an objective ! the objective is :", currentObjectiveNode.name)
		nodePathToObjective.remove_at(0)
		travellingToNode = nodePathToObjective[0]
		return
	
	if currentObjectiveNode == null:
		if NodeIsBranchingPath():
			print("-> there are multiple paths ahead !")
			travellingToNode = GAMEMANAGER.GetClosestUnexploredNode()
		elif IsCurrentNodeNotADeadEnd() :
			print("-> current node is not a dead end ! \n")
			travellingToNode = GAMEMANAGER.GetClosestUnexploredNode()
			# Path is not a dead end, get next closest path
		elif GAMEMANAGER.nodesUnexplored.size() > 0:
			print("\nthere are currently ", GAMEMANAGER.nodesUnexplored.size(), " paths unexplored \n")
			var closest = GAMEMANAGER.GetClosestUnexploredNode()
			nodePathToObjective = GAMEMANAGER.RequestPath(travellingToNode,closest)
			currentObjectiveNode = nodePathToObjective[0]
			# is at least 1 path explorable ?
		else:
			pass
			print("\nthere are no longer any paths to go to. You are boned.")
			set_physics_process(false)

func TravellingToNode(line : Line2D):
	var toBeVel : Vector2
	toBeVel = (travellingToNode.global_position - global_position).normalized() * character.SPEED
	character.velocity = toBeVel
	character.move_and_slide()

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
