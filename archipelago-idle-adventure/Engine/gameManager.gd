class_name GameManager extends Node2D

var playerCharacter : CharacterBody2D

# the player will send info about all nodes he encounters. They will be stored in these arrays :
var nodesThatCanBeExplored : Array[MovementNodes] # Log of all nodes found currently
var nodesThatHaveBeenExplored : Array[MovementNodes] # Nodes that have been explored
var nodesUnexplored : Array[MovementNodes] # Remainder of what to explore
var aStar2D : AStar2D = AStar2D.new()
var hintLocations : Array[MovementNodes]

func PlayerReady(startNode : MovementNodes, characterNode : CharacterBody2D):
	playerCharacter = characterNode
	nodesThatCanBeExplored.append(startNode)
	nodesUnexplored.append(startNode)
	aStar2D.add_point(0, startNode.global_position)
	ShowArraysOnLabels()

func HasCurrentNodeBeenExplored(gotToNode : MovementNodes) -> bool:
	#print(gotToNode in nodesThatHaveBeenExplored)
	return gotToNode in nodesThatHaveBeenExplored

func RefreshLists(arrivedToNode : MovementNodes):
	nodesThatHaveBeenExplored.append(arrivedToNode)
	# just arrived at node, it has now been explored.
	var possibleNewNodes : Array[MovementNodes] = arrivedToNode.connectedNodes
	# Get all connections of the node
	for i in possibleNewNodes.size():
		#print("---\n checking possible new node : ", arrivedToNode.connectedNodes[i], "\n ---")
		# For all the connections it has...
		if nodesThatCanBeExplored.has(possibleNewNodes[i]) == false:
			# If it's not one that's already known of :
			nodesThatCanBeExplored.append(possibleNewNodes[i])
			# Add to the list of nodes to be potentially visited
			AddtoAStar(ReturnEntryFromList(arrivedToNode),ReturnEntryFromList(possibleNewNodes[i]),possibleNewNodes[i].position)
			
			#print("Astart list is : ", aStar2D.get_available_point_id())
			#Add to the AStar path finding the new node, and its position, as well as connect it
			# Give the arrivedToNode to say what it is connected to
	
	nodesUnexplored.clear()
	for i in nodesThatCanBeExplored.size():
		if nodesThatHaveBeenExplored.has(nodesThatCanBeExplored[i]) == false:
			nodesUnexplored.append(nodesThatCanBeExplored[i])
	ShowArraysOnLabels()

func ReturnEntryFromList(what : MovementNodes,list : Array = nodesThatCanBeExplored)-> int:
	if list.find(what) != -1:
		return list.find(what)
	else:
		printerr("Entry was not in list !")
		return -1

func AddtoAStar(id_arrivedAt : int, id_foundNode:int, pos_foundNode: Vector2):
	aStar2D.add_point(id_foundNode, pos_foundNode)
	aStar2D.connect_points(id_foundNode, id_arrivedAt)


func RequestPath(startNode: MovementNodes, endNode: MovementNodes) -> Array[MovementNodes]:
	var idStartNode : int = nodesThatCanBeExplored.find(startNode)
	var idEndNode : int = nodesThatCanBeExplored.find(endNode)
	var pathInVec2 := aStar2D.get_point_path(idStartNode, idEndNode)
	var pathInMovementNodes : Array[MovementNodes]
	for i in pathInVec2.size():
		var nodeposition : Vector2 = pathInVec2[i]
		for n in nodesThatCanBeExplored.size():
			if nodeposition == nodesThatCanBeExplored[n].position:
				pathInMovementNodes.append(nodesThatCanBeExplored[n])
	#print(pathInMovementNodes)
	return pathInMovementNodes

func IsHintAvailable() -> MovementNodes:
	#Returns closest available hint
	var availableHintLocations : Array[MovementNodes]
	if hintLocations.size() == 0:
		return null
		# No hints !
	else:
		for i in hintLocations:
			if hintLocations[i] in nodesThatCanBeExplored:
				availableHintLocations.append(hintLocations)
	if availableHintLocations.size() == 0:
		return null
		#There are no hints available.
	elif availableHintLocations.size() == 1:
		return availableHintLocations[0]
	else:
		var lastHintDistance : float = playerCharacter.global_position.distance_to(availableHintLocations[0].global_position)
		var closestHint : MovementNodes = availableHintLocations[0]
		for i in availableHintLocations.size():
			if lastHintDistance < playerCharacter.global_position.distance_to(availableHintLocations[i].global_position):
				closestHint = availableHintLocations[i]
		return null

func ObtainedItem():
	pass

func IsGoMode():
	#checks if the playerCharacter can go finish the game
	pass

func CheckPreviouslyUnavailablePaths():
	#Character has reached a dead end, or a path that is blocked for now.
	#return a path that he can reach currently.
	#if null, he waits until item is obtained to unlock him.
	pass

func ShowArraysOnLabels():
	for i in get_node("Debug Show Lists/nodesThatCanBeExplored").get_child_count():
		#print("delete canBeExplored child", i)
		get_node("Debug Show Lists/nodesThatCanBeExplored").get_child(i).queue_free()
	for i in get_node("Debug Show Lists/nodesThatHaveBeenExplored").get_child_count():
		#print("delete HaveBeenExplored child", i)
		get_node("Debug Show Lists/nodesThatHaveBeenExplored").get_child(i).queue_free()
	for i in get_node("Debug Show Lists/nodesUnexplored").get_child_count():
		#print("delete unexplored child", i)
		get_node("Debug Show Lists/nodesUnexplored").get_child(i).queue_free()
	for i in nodesThatCanBeExplored.size():
		var label = Label.new()
		get_node("Debug Show Lists/nodesThatCanBeExplored").add_child(label)
		label.text = str("can be explored : " + nodesThatCanBeExplored[i].name + "||")
	for i in nodesThatHaveBeenExplored.size():
		var label = Label.new()
		get_node("Debug Show Lists/nodesThatHaveBeenExplored").add_child(label)
		label.text = str("has been explored : " + nodesThatHaveBeenExplored[i].name + "||")
	for i in nodesUnexplored.size():
		var label = Label.new()
		get_node("Debug Show Lists/nodesUnexplored").add_child(label)
		label.text = str("unexplored : " + nodesUnexplored[i].name + "||")

func GetClosestUnexploredNode() -> MovementNodes:
	var currentNodeChosen : MovementNodes = nodesUnexplored[0]
	var charGlobalPos : Vector2 = playerCharacter.global_position
	var firstNodeGlobalPos : Vector2 = nodesUnexplored[0].global_position
	var currentNodeDistance : float = charGlobalPos.distance_to(firstNodeGlobalPos)
	for i in nodesUnexplored.size():
		if charGlobalPos.distance_to(nodesUnexplored[i].global_position) < currentNodeDistance:
			currentNodeChosen = nodesUnexplored[i]
			currentNodeDistance = charGlobalPos.distance_to(nodesUnexplored[i].global_position)
	return currentNodeChosen

func GetClosestNodeFromList(nodeList : Array[MovementNodes]) -> MovementNodes:
	#print("\nnode list is : ",nodeList)
	var charGlobalPos : Vector2 = playerCharacter.global_position
	var currentNodeChosen : MovementNodes = nodeList[0]
	var firstNodeGlobalPos : Vector2 = nodeList[0].global_position
	var currentNodeDistance : float = charGlobalPos.distance_to(firstNodeGlobalPos)
	#Get the first closest unexplored
	for i in nodeList.size():
		if nodesUnexplored.has(nodeList[i]):
			currentNodeChosen = nodeList[i]
			firstNodeGlobalPos = nodeList[i].global_position
			currentNodeDistance = charGlobalPos.distance_to(firstNodeGlobalPos)
			break
	for i in nodeList.size():
		if nodesUnexplored.has(nodeList[i]):
			#print("a ",nodeList[i])
			if charGlobalPos.distance_to(nodeList[i].global_position) < currentNodeDistance:
				currentNodeChosen = nodeList[i]
				currentNodeDistance = charGlobalPos.distance_to(nodeList[i].global_position)
	#print("chosen node has been :", currentNodeChosen)
	#print("nodesUnexplored to see something : ", nodesUnexplored)
	return currentNodeChosen
