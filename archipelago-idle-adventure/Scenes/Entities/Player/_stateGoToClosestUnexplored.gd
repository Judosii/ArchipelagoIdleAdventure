extends _State

@export var _stateExplore : _State

var nodePathToObjective : Array[MovementNodes]
var currentObjectiveNode : MovementNodes

func ActivateState():
	super.ActivateState()
	var closest = GAMEMANAGER.GetClosestUnexploredNode()
	nodePathToObjective = GAMEMANAGER.RequestPath(playerCharacter.travellingToNode,closest)
	nodePathToObjective.remove_at(0)
	currentObjectiveNode = nodePathToObjective[0]
	playerCharacter.travellingToNode = currentObjectiveNode
	print(playerCharacter.travellingToNode)

func ArrivedAtNodeLogic():
	super.ArrivedAtNodeLogic()
	nodePathToObjective.remove_at(0)
	if nodePathToObjective.size() == 0 :
		stateMachine.SwitchState(_stateExplore.name)
	else:
		currentObjectiveNode = nodePathToObjective[0]
		playerCharacter.travellingToNode = currentObjectiveNode
