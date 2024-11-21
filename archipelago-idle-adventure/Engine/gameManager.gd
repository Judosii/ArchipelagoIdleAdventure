class_name GameManager extends Node2D

var character : CharacterBody2D

# the player will send info about all nodes he encounters. They will be stored in these arrays :
var nodesThatCanBeExplored : Array[MovementNodes] # Log of all nodes found currently
var nodesThatHaveBeenExplored : Array[MovementNodes] # Nodes that have been explored
var nodesUnexplored : Array[MovementNodes] # Remainder of what to explore
var aStar2D : AStar2D = AStar2D.new()
var hintLocations : Array[MovementNodes]

func PlayerReady(startNode : MovementNodes, characterNode : CharacterBody2D):
	character = characterNode
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
	 #feed IDs from nodesThatCanBeExplored, so that the ID stays consistent.
	#print("\nAddToStar : ")
	#print("-arrived at : ", id_arrivedAt, " ( is: ", nodesThatHaveBeenExplored[id_arrivedAt].name, " )")
	#print("-foundNode : ", id_foundNode, " ( is: ", nodesThatHaveBeenExplored[id_foundNode].name, " )")
	#print("-positionNode : ", pos_foundNode, " ( is: ", pos_foundNode, " )")
	#print("\n-foundNode : ", id_foundNode, "\n-nodeposition : ", pos_foundNode))
	
	#print("added", id_foundNode, " to astar")
	aStar2D.add_point(id_foundNode, pos_foundNode)
	aStar2D.connect_points(id_arrivedAt, id_foundNode)
	
	#print("AStar's point count is : ",aStar2D.get_point_count(), "\n")

func RequestPath(startNode: MovementNodes, endNode: MovementNodes) -> Array[MovementNodes]:
	var idStartNode : int = nodesThatCanBeExplored.find(startNode)
	var idEndNode : int = nodesThatCanBeExplored.find(endNode)
	return aStar2D.get_point_path(idStartNode, idEndNode)

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
		var lastHintDistance : float = character.global_position.distance_to(availableHintLocations[0].global_position)
		var closestHint : MovementNodes = availableHintLocations[0]
		for i in availableHintLocations.size():
			if lastHintDistance < character.global_position.distance_to(availableHintLocations[i].global_position):
				closestHint = availableHintLocations[i]
		return null

func ObtainedItem():
	pass

func IsGoMode():
	#checks if the character can go finish the game
	pass

func CheckPreviouslyUnavailablePaths():
	#Character has reached a dead end, or a path that is blocked for now.
	#return a path that he can reach currently.
	#if null, he waits until item is obtained to unlock him.
	pass

func ShowArraysOnLabels():
	for i in get_node("HBoxContainer/nodesThatCanBeExplored").get_child_count():
		#print("delete canBeExplored child", i)
		get_node("HBoxContainer/nodesThatCanBeExplored").get_child(i).queue_free()
	for i in get_node("HBoxContainer/nodesThatHaveBeenExplored").get_child_count():
		#print("delete HaveBeenExplored child", i)
		get_node("HBoxContainer/nodesThatHaveBeenExplored").get_child(i).queue_free()
	for i in get_node("HBoxContainer/nodesUnexplored").get_child_count():
		#print("delete unexplored child", i)
		get_node("HBoxContainer/nodesUnexplored").get_child(i).queue_free()
	for i in nodesThatCanBeExplored.size():
		var label = Label.new()
		get_node("HBoxContainer/nodesThatCanBeExplored").add_child(label)
		label.text = str("can be explored : " + nodesThatCanBeExplored[i].name + "||")
	for i in nodesThatHaveBeenExplored.size():
		var label = Label.new()
		get_node("HBoxContainer/nodesThatHaveBeenExplored").add_child(label)
		label.text = str("has been explored : " + nodesThatHaveBeenExplored[i].name + "||")
	for i in nodesUnexplored.size():
		var label = Label.new()
		get_node("HBoxContainer/nodesUnexplored").add_child(label)
		label.text = str("unexplored : " + nodesUnexplored[i].name + "||")

func GetClosestUnexploredNode() -> MovementNodes:
	var currentNodeChosen : MovementNodes = nodesUnexplored[0]
	var currentNodeDistance : float = character.global_position.distance_to(nodesUnexplored[0].global_position)
	for i in nodesUnexplored.size():
		if character.global_position.distance_to(nodesUnexplored[i].global_position) < currentNodeDistance:
			currentNodeChosen = nodesUnexplored[i]
			currentNodeDistance = character.global_position.distance_to(nodesUnexplored[i].global_position)
	return currentNodeChosen
