extends _State

@export var stateGoToHint : _State
@export var distantUnexplored : _State

func ActivateState():
	super.ActivateState()
	if GAMEMANAGER.nodesUnexplored.size() > 0:
		ArrivedAtNodeLogic()
	else:
		playerCharacter.set_physics_process(false)

func ArrivedAtNodeLogic():
	if GAMEMANAGER.IsHintAvailable():
		stateMachine.SwitchState(stateGoToHint.name)
		pass
		#Is there a hint available to access ?
	
	if NodeIsBranchingPath():
		#print("-> there are multiple paths ahead !")
		playerCharacter.travellingToNode = GAMEMANAGER.GetRandomNodeFromList(playerCharacter.travellingToNode.connectedNodes)
	
	elif IsCurrentNodeNotADeadEnd() :
		#print("-> current node is not a dead end ! \n")
		playerCharacter.travellingToNode = GAMEMANAGER.GetRandomNodeFromList(playerCharacter.travellingToNode.connectedNodes)
		# Path is not a dead end, get next closest path
	
	elif GAMEMANAGER.nodesUnexplored.size() > 0:
		#print("\nthere are currently ", GAMEMANAGER.nodesUnexplored.size(), " paths unexplored \n")
		stateMachine.SwitchState(distantUnexplored.name)
		# is at least 1 path explorable ?
	
	else:
		#print("\nthere are no longer any paths to go to. You are boned.")
		set_physics_process(false)
