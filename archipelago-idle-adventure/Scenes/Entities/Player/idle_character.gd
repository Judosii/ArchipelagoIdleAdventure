class_name character extends CharacterBody2D

signal characterArrivedAtNode

const SPEED = 100
const JUMP_VELOCITY = -400.0


@export var _stateMachine : StateMachine

@export var startNode : MovementNodes

@export var travellingToNode : MovementNodes #node the character is going towards
var currentObjectiveNode : MovementNodes = null
var nodePathToObjective : Array[MovementNodes]
# do set them at start to avoid a crash :D
# by design travellingToNode can only be a node that has been in nodesThatCanBeExplored
# once a node has been reached at least once, add it to nodesThatHaveBeenExplored, AND...
# ... add its connections to nodesThatCanBeExplored if they haven't been there already.
# nodesUnexplored will be used when a character reaches a dead end, to determine where to go next.

func _ready():
	GAMEMANAGER.PlayerReady(startNode, self)

func _physics_process(delta: float) -> void:
	_stateMachine.StateFunction(delta)

#func _physics_process(delta):
	#var label : Label = get_node("Label")
	#label.text = travellingToNode.name
	#if position.distance_to(travellingToNode.position) < 1 :
		#ArrivedAtNode()
	#else:
		#TravellingToNode()

func ArrivedAtNode():
	if nodePathToObjective.size() > 0:
		get_node("Label").text = str(nodePathToObjective[0].name)
	print("-----------------------------------------------------------")
	print("Arrived at a node !")
	velocity = Vector2(0,0)
	#print(GAMEMANAGER.HasCurrentNodeBeenExplored(travellingToNode))
	if !GAMEMANAGER.HasCurrentNodeBeenExplored(travellingToNode):
		print("Current node has NOT been explored !")
		print("-> adding to game manager lists and updating")
		# Node has been explored before
		GAMEMANAGER.RefreshLists(travellingToNode)
	
	if GAMEMANAGER.IsHintAvailable():
		print("-> hinted location available to obtain !")
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
		elif HasObtainedItem():
			print("-> has, in fact, obtained item !\n")
			# Recalculate open paths
			# Also check for Go Mode
			if GAMEMANAGER.IsGoMode():
				print("character is go mode !")
				set_physics_process(false)
			elif GAMEMANAGER.CheckPreviouslyUnavailablePaths():
				print("not go mode yet, checking a new path")
				set_physics_process(false)
			else:
				print("need to wait for an item.")
				set_physics_process(false)
				#Needs to wait for an item.
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
