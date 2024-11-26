class_name _State extends Node2D

@export var playerCharacter : character
@export var stateMachine : StateMachine

func _ready() -> void:
	stateMachine = get_parent()
	playerCharacter = stateMachine.get_parent()

func StateFunctionality():
	pass

func ActivateState():
	stateMachine.currentState = self

func DeactivateState():
	pass

func ArrivedAtNodeLogic():
	pass

func IsCurrentNodeNotADeadEnd() -> bool:
	var nodeConnectionsList = playerCharacter.travellingToNode.connectedNodes
	var nodeConnectionsSize = playerCharacter.travellingToNode.connectedNodes.size()
	#print("\nIs current node a dead end ?")
	#print("- node's connections amount to : ",nodeConnectionsSize)
	if nodeConnectionsSize == 1:
		if nodeConnectionsList[0] not in GAMEMANAGER.nodesThatHaveBeenExplored:
			#print("-> DeadEnd node; one path available.")
			return true
		else:
			#print("-> dead end")
			return false
	
	elif nodeConnectionsSize == 2:
		#print("-> corridor node, 2 paths available")
		var connectionsExplored : int = 0
		for i in nodeConnectionsSize:
			if nodeConnectionsList[i] in GAMEMANAGER.nodesThatHaveBeenExplored:
				connectionsExplored += 1
		#print("there are ", connectionsExplored, "explored paths from this node")
		if connectionsExplored == nodeConnectionsSize:
			#print("-> all current connections have already been explored.")
			return false
		else:
			#print("One path is still unexplored from this node.")
			return true
	else:
		#print("reached end of IsCurrentNodeADeadEnd. Something's wrong.")
		return true

func NodeIsBranchingPath() -> bool:
	#print("\n is current node branching into paths ?")
	var numberOfConnectionsAlreadyVisited : int = 0
	for i in playerCharacter.travellingToNode.connectedNodes.size():
		if playerCharacter.travellingToNode.connectedNodes[i] in GAMEMANAGER.nodesThatHaveBeenExplored:
			numberOfConnectionsAlreadyVisited += 1
	if playerCharacter.travellingToNode.connectedNodes.size() - numberOfConnectionsAlreadyVisited > 1:
		#print("- yes")
		return true
	else:
		#print("- no")
		return false
